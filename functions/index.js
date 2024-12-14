const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const functions = require("firebase-functions/v2");
// const { onDocumentCreated, https } = require('firebase-functions/v2');
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendOfferNotification = onDocumentCreated(
    "offer_notification/{offerId}",
    async (event) => {
      const snapshot = event.data;

      if (!snapshot) {
        console.log("No data in Firestore snapshot.");
        return;
      }

      const offerData = snapshot.data();
      const offerTitle = offerData.title || "New Offer!";
      const notificationTitle = "Biteflow";
      const notificationBody = `${offerTitle}`;

      try {
        const usersSnapshot = await admin.firestore().collection("users").get();
        const tokensSet = new Set();

        usersSnapshot.forEach(async (doc) => {
          const userData = doc.data();
          if (userData.fcmToken && userData.fcmToken.trim() !== "") {
            tokensSet.add(userData.fcmToken);
            await admin.firestore().collection("users").doc(doc.id).update({
              unseenOfferCount: admin.firestore.FieldValue.increment(1),
            });
          }
        });
        const tokens = Array.from(tokensSet); // Convert Set to Array

        if (tokens.length > 0) {
          const message = {
            notification: {
              title: notificationTitle,
              body: notificationBody,
            },
            data: {
              type: "offer", // This is where the type is set
            },
            tokens: tokens,
          };

          const responses = await admin.messaging().
              sendEachForMulticast(message);

          let successCount = 0;
          let failureCount = 0;

          responses.forEach((response) => {
            if (response.success) {
              successCount++;
            } else {
              failureCount++;
              console.error("Failed notification:", response.error);
            }
          });
          console.log(`Notifications sent successfully to ${successCount}`);
          if (failureCount > 0) {
            console.log(`Failed to send to ${failureCount} devices.`);
          }
        } else {
          console.log("No valid FCM tokens found for notifications.");
        }
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });


exports.sendSplitRequestNotification = functions.https.
    onCall(async (data) => {
      try {
        console.log("Received data:", data);

        const userIds = data.data.userIds;
        const title = data.data.title;
        const message = data.data.message;


        // Validate input
        if (!userIds || !Array.isArray(userIds) || userIds.length === 0) {
          return {
            success: false,
            message: `Invalid user IDs: ${JSON.stringify(userIds)} 
            and data is: ${data}`,
          };
        }

        const tokensSet = new Set();

        // Batch processing for more than 10 user IDs
        for (let i = 0; i < userIds.length; i += 10) {
          const batchUserIds = userIds.slice(i, i + 10);

          const usersSnapshot = await admin.firestore()
              .collection("users")
              .where("id", "in", batchUserIds)
              .get();

          usersSnapshot.forEach((doc) => {
            const userData = doc.data();
            if (userData.fcmToken && userData.fcmToken.trim() !== "") {
              tokensSet.add(userData.fcmToken);
            }
          });
        }

        const tokens = Array.from(tokensSet);

        if (tokens.length > 0) {
          const notificationMessage = {
            notification: {
              title: title || "New Split Request",
              body: message || "You have a new split request.",
            },
            data: {
              type: "split_request",
            },
            tokens: tokens,
          };

          const responses = await admin.messaging().
              sendEachForMulticast(notificationMessage);

          console.log(`Successfully sent ${responses.successCount}.`);
          if (responses.failureCount > 0) {
            console.log(`Failed to send ${responses.failureCount}.`);
          }

          return {
            success: true,
            message: "Notifications sent.",
            successCount: responses.successCount,
            failureCount: responses.failureCount,
          };
        } else {
          console.log("No valid FCM tokens found.");
          return {success: false, message: "No valid tokens found."};
        }
      } catch (error) {
        console.error("Error sending notifications:", error);
        return {success: false, message: error.message};
      }
    });
