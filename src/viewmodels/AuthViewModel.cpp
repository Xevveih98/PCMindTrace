// viewmodel/authviewmodel.cpp
#include "AuthViewModel.h"
#include "src/models/UserModel.h"

bool AuthViewModel::registerUser(const QString &login, const QString &email, const QString &password) {
    return UserModel::registerUser(login, email, password);
}

bool AuthViewModel::loginUser(const QString &login, const QString &password) {
    return UserModel::loginUser(login, password);
}

bool AuthViewModel::recoverPassword(const QString &email, const QString &newPass, const QString &newPassCheck) {
    if (newPass != newPassCheck)
        return false;
    return UserModel::recoverPassword(email, newPass);
}

bool AuthViewModel::isUserLoggedIn() {
    return UserModel::isUserLoggedIn();
}

void AuthViewModel::logout() {
    UserModel::logoutAll();
}

