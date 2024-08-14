const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.bookSuccessful = functions.https.onCall(async (data, context) => {
  const { employeeId, selectedTimeSlot, date, userId, shopId, selectedMenuIds, customerName } = data;

  // Example logic to send notification
  try {
    const payload = {
      notification: {
        title: 'Booking Confirmed',
        body: `A new booking has been made for ${selectedTimeSlot} on ${date}.`,
      },
    };

    // Assume you have the employee's FCM token saved in Firestore
    const employeeDoc = await admin.firestore().collection('employees').doc(employeeId).get();
    const fcmToken = employeeDoc.data().fcmToken;

    if (fcmToken) {
      await admin.messaging().sendToDevice(fcmToken, payload);
      return { success: true };
    } else {
      return { error: 'FCM token not found' };
    }
  } catch (error) {
    console.error('Error sending notification:', error);
    throw new functions.https.HttpsError('unknown', 'Error sending notification');
  }
});
