# Flutter Signup Form Quest

**Course:** MAD 4360 — Mobile App Development  
**Activity:** In-Class Activity 10  
**Student:** Suma Enjam  
**Track:** Graduate  
**Tasks Completed:** Task A + Task C

## 1. Project Overview

This project is a simple signup application built using Flutter. The main goal was to understand how forms, validation, and state management work in Flutter.

I implemented a signup form with name, email, password, and confirm password fields. I also added a local signup-tip feature that provides basic password safety tips without using the internet or a real AI service.

## 2. Features Implemented

### Core Signup Form
- Name, email, and password input fields
- Validation for empty fields and invalid email addresses
- Password length validation
- Success message after entering valid details

### Task A: Local Signup Tip Simulation
- Added a Get a signup tip button
- Stored predefined password safety tips locally
- Displayed a loading indicator before showing a tip
- Added error handling when tips are unavailable
- Added a Retry button
- Clearly labeled tips as preset demo content, not live AI

### Task C: Confirm & Celebrate
- Added a confirm password field
- Checked whether the password and confirm password matched
- Displayed an error for mismatched passwords
- Added a personalized success message using the entered name

## 3. Testing

I manually tested the application using different input combinations.

| Test Case | Result |
|---|---|
| Submitted empty fields | Validation errors displayed |
| Entered different passwords | Password mismatch error displayed |
| Entered matching passwords | Personalized success message displayed |
| Requested a signup tip | Preset tip displayed after loading |
| Simulated missing tips | Error message and Retry button displayed |
| Disabled missing tips and retried | Tip displayed successfully |

All six tests passed during manual testing.

## 4. Graduate Reflection

### Question 1: Identify one privacy boundary in the local tip feature. What information does it keep out, and why?

One important thing I focused on was keeping the signup tips separate from the user's personal information. The tip feature does not use the name, email, or password entered in the form. Instead, it displays predefined tips stored locally in the application. I think this is a better approach for this activity because it avoids unnecessarily sharing or processing sensitive information.

### Question 2: What should the UI do when local tip data is empty or missing? Explain your error and retry behavior.

When the local tips are unavailable, the app displays an error message instead of showing an empty result. I added a Retry button so the user can try again. During testing, I enabled the missing-tips option and checked whether the error appeared correctly. After disabling the option and clicking Retry, the app displayed a tip successfully.

### Question 3: Describe one trade-off in your local design and a practical improvement.

I chose to use predefined tips because they are simple to implement and work without an internet connection. However, one limitation is that the tips are not personalized and can become repetitive. One improvement would be to add more categories, such as account safety and password management, so users can receive different types of advice. This would make the feature more useful while still keeping it local and privacy-friendly.

## 5. Individual Contribution

I worked on the signup form, including input validation and password confirmation. I also implemented the local signup-tip feature with loading, success, error, and retry states.

I tested the form with valid and invalid inputs and checked whether the tip feature handled missing data correctly.

indivi