import * as constants from './constants.js';

const togglePassword = document.querySelector("#togglePassword");
const password = document.querySelector("#password");
const messageAlert = document.querySelector("#alertMessage");
const buttonCloseMessageAlert = document.querySelector("#btnCloseAlert");
const textMessageAlert = document.querySelector("#textAlerMessage");
const btnSubmit = document.querySelector("#btnSubmit");
const formSubmit = document.querySelector("#formSubmit");
const paramAuthFailureMsg = "authFailureMsg";
const paramAuthFailure = "authFailure";

const hideMessageError = () => messageAlert.classList.add('hide');

if (togglePassword) {
  togglePassword.addEventListener("click", function () {
    const type = password.getAttribute("type") === "password" ? "text" : "password";
    password.setAttribute("type", type);
    this.classList.toggle("bi-eye");
  });
}

if (buttonCloseMessageAlert) {
  buttonCloseMessageAlert.addEventListener("click", function () {
    hideMessageError();
  });
}

const showMessageError = (message) => {
  textMessageAlert.innerHTML = message.replace("?", "");
  messageAlert.classList.remove('hide');
}

if (btnSubmit) {
  btnSubmit.addEventListener("click", function () {
    const userName = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    if (!userName || !password) {
      showMessageError('Ingresa tu usuario y/o contraseña.');
      return;
    }

    if (userName.includes('@invex.com')) {
      document.getElementById('username').value = userName + '@carbon.super';
    } else if (userName.includes('@invex.com@carbon.super')) {
      document.getElementById('username').value = userName;
    }

    hideMessageError();
    btnSubmit.disabled = true;
    formSubmit.submit();
  });
}

$(document).ready(function () {
  const urlParams = new URLSearchParams(window.location.search);
  const isAuthFailure = urlParams.get(paramAuthFailure);
  const isAuthFailureMsg = urlParams.get(paramAuthFailureMsg);

  if (isAuthFailure) window.location.href = constants.modifyUrl(isAuthFailureMsg);
  if (isAuthFailureMsg) {
    showMessageError(isAuthFailureMsg);
    btnSubmit.disabled = false;
  }
});