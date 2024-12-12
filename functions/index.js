const {onDocumentCreated} = require("firebase-functions/v2/firestore");
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
        const tokens = [];

        usersSnapshot.forEach(async (doc) => {
          const userData = doc.data();
          if (userData.fcmToken && userData.fcmToken.trim() !== "") {
            tokens.push(userData.fcmToken);
          }

          // Increment unseenOfferCount
          await admin.firestore().collection("users").doc(doc.id).update({
            unseenOfferCount: admin.firestore.FieldValue.increment(1),
          });
        });

        if (tokens.length > 0) {
          const message = {
            notification: {
              title: notificationTitle,
              body: notificationBody,
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
