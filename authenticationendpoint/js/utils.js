/**
 * @param {string} componentText 
 * @param {string} componentAlert 
 * @param {string | null} message 
 */
const showMessageError = (componentText, componentAlert, message) => {
  if (componentAlert && componentText) {
    const textMessageAlert = document.querySelector(componentText);

    const messageAlert = document.querySelector(componentAlert);
    messageAlert.classList.remove('hide');

    if (!message) messageAlert.classList.add('hide');
    else textMessageAlert.innerHTML = message.replace("?", "");
  }
}

/**
 * @param {string} buttonId 
 * @param {string} alertId 
 */
const hideMessageError = (buttonId, alertId) => {
  if (!buttonId || !alertId) return;

  const button = document.querySelector(buttonId);
  button.addEventListener("click", function () {
    const messageAlert = document.querySelector(alertId);
    messageAlert.classList.add('hide');
  });
}

/**
 * @param {string} inputId 
 * @param {string} toggleId 
 */
const passwordEye = (inputId, toggleId) => {
  const password = document.querySelector(inputId);
  const toggle = document.querySelector(toggleId);

  toggle.addEventListener("click", function () {
    const type =
      password.getAttribute("type") === "password" ? "text" : "password";
    password.setAttribute("type", type);
    this.classList.toggle("bi-eye");
  });
}