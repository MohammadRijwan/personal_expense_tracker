# Personal Tracker App

A mobile application for users to track and manage personal expenses.


## Features
```sh
• Add Expense : Users can input the amount, date, and a brief description.
• View Expenses: Display expenses in a list, sorted and filterable by date.
• Edit/Delete Expense : Modify or remove expense entries.
• Expense Summary : Show summaries categorized by type, on a weekly or monthly basis.
• Reminder Notifications: Set up reminders for users to record their daily expenses.
```

## Libraries used
```sh
• Riverpod: used for state management
• Isar: used for local database.
• Mocktail: for unit testing, mock generation
• Flutter Flavor: for getting the flavor object. 
```

## Project Structure and Architecture

This code uses clean architecture with domain, data and ui layer implementations to create the app. The key feature of app is to add/update/delete the expense and 
filter the expense monthly and weekly. The app displays a list of Expenses from the local database. 

## Directory Structure
```sh
lib->
main.dart
splash_screen.dart
    src->
        core->
              common->
                    api_result.dart
                    api_result.freezed.dart
                    usecase_result.dart
                    usecase_result.freezed.dart
              constant->
                        theme->
                             light_theme.dart
                        font.dart
              datasource->
                        local->
                            local_db.dart
              dependency->
                        dependency_injection.dart
              util->
                        alarm_schedule.dart
                        app_router.dart
                        flutter_toast.dart
              widget->
                        text_widget.dart
                        textfield_widget.dart
        feature->
                expense->
                        data->
                            expense_repository.dart
                        domain->
                                interface->
                                        i_expense_repository.dart
                                model->
                                        expense.dart
                                        expense.g.dart
                                usecase->
                                        expense_usecase.dart
                                        summary_usecase.dart
                        ui->
                                add_expense->
                                        add_expense_screen.dart
                                        add_expense_vm.dart
                                expense_list->
                                        expense_list_screen.dart
                                        expense_list_vm.dart
                                view_summary->
                                        view_summary_screen.dart
                                        view_summary_vm.dart
```
## The app is organized into layers, with the each having its own responsibilities

• main.dart file at the top, entry point for application.

• splash.dart file, which initializes the app. 


## The features/home directory contains the code for the home page feature.

## ui layer (ui folder includes)

• Displays the UI for add expense, expense list and view summary of expenses.

• UI folder also includes view models for all the above screens. View Model is responsible to displaying the data in the screen and state.


## domain layer contains business logic

• Domain layer contains interface, model, and usecase defines business logic. It contains methods for getting expense data from the repository. Filtering expense, adding/updating and deleting the expense.

## data layer contains repository which fetches characters from api

Data layer contain expense repository, it is responsible for fetching data from the Isar local database and convert to list of expenses.


## To run app -> flutter build  command

## Unit tests

Using mocktail library for testing.

Tests are located similarly to actual code, test/features folder contains all tests

## Screenshots

![App Screenshot](https://github.com/MohammadRijwan/personal_expense_tracker/blob/master/screenshots/1.png)
![App Screenshot](https://github.com/MohammadRijwan/personal_expense_tracker/blob/master/screenshots/2.png)
![App Screenshot](https://github.com/MohammadRijwan/personal_expense_tracker/blob/master/screenshots/3.png)
![App Screenshot](https://github.com/MohammadRijwan/personal_expense_tracker/blob/master/screenshots/4.png)
![App Screenshot](https://github.com/MohammadRijwan/personal_expense_tracker/blob/master/screenshots/5.png)
![App Screenshot](https://github.com/MohammadRijwan/personal_expense_tracker/blob/master/screenshots/6.png)
![App Screenshot](https://github.com/MohammadRijwan/personal_expense_tracker/blob/master/screenshots/7.png)
![App Screenshot](https://github.com/MohammadRijwan/personal_expense_tracker/blob/master/screenshots/8.png)






