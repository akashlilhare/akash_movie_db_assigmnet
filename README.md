
# Movie App

1. User Login Page with Complete Form Validation:

    - Create a login screen widget with necessary UI elements such as text fields for email and password, a login button, and error message placeholders.
    - Implement form validation by adding validation logic to the email and password fields. Use regular expressions or predefined validation methods to ensure proper email and password formats.
    - Display error messages dynamically based on validation results.
    - Connect the login button to a method that performs authentication. This method should validate the form inputs, handle success and error cases, and navigate to the appropriate screen upon successful login.

2. Registration Page:
    - Create a registration screen widget with required input fields such as name, email, password, etc.
    - Implement form validation similar to the login page by validating the email and password fields.
    - Add a registration button that triggers a registration method upon tapping.
    - Inside the registration method, validate the form inputs and call an API or perform necessary database operations to create a new user.
    - Handle success and error cases, and navigate the user to the appropriate screen based on the result.

3. Implement Firebase Push Notification:
    - Add the necessary Firebase dependencies to your `pubspec.yaml` file.
    - Configure Firebase in your Flutter project by following Firebase's documentation for Flutter.
    - Generate the necessary certificates and keys to enable push notifications for your application.
    - Write a method to handle the device token retrieval. This token will be used to send push notifications to the device.
    - Implement the logic to handle push notifications by listening to Firebase's messaging stream. You can handle different types of notifications based on your application's requirements.
    - Use the obtained device token to send push notifications using Firebase Cloud Messaging (FCM). You can trigger push notifications from the server-side or manually send notifications from the Firebase console.

# Screen Shorts
![SS1](https://github.com/akashlilhare/akash_movie_db_assigmnet/blob/master/screen_short/img1.jpeg?raw=true)

![SS2](https://github.com/akashlilhare/akash_movie_db_assigmnet/blob/master/screen_short/img2.jpeg?raw=true)

![SS3](https://github.com/akashlilhare/akash_movie_db_assigmnet/blob/master/screen_short/img3.jpeg?raw=true)

![SS4](https://github.com/akashlilhare/akash_movie_db_assigmnet/blob/master/screen_short/img4.jpeg?raw=true)

