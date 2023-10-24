const togglePassword = document.querySelector("#togglePassword");
const password = document.querySelector("#password");
const messageAlert = document.querySelector("#alertMessage");
const buttonCloseMessageAlert = document.querySelector("#btnCloseAlert");
const textMessageAlert = document.querySelector("#textAlerMessage");
const btnSubmit = document.querySelector("#btnSubmit");
const formSubmit = document.querySelector("#formSubmit");
const errorMsgURL = "authFailureMsg";

togglePassword.addEventListener("click", function () {
  const type = password.getAttribute("type") === "password" ? "text" : "password";
  password.setAttribute("type", type);
  this.classList.toggle("bi-eye");
});

buttonCloseMessageAlert.addEventListener("click", function () {
  messageAlert.classList.add('hide');
});

const showMessageError = (message) => {
  textMessageAlert.innerHTML = message;
  messageAlert.classList.remove('hide');
}

const removeParamQueryURL = (param) => {
  const url = new URL(window.location.href)
  const params = new URLSearchParams(url.search.slice(1))
  params.delete(param)
  window.history.replaceState(
    {},
    '',
    `${window.location.pathname}?${params}${window.location.hash}`,
  )
}

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

  messageAlert.classList.add('hide');
  formSubmit.submit();
});


$(document).ready(function () {
  const urlParams = new URLSearchParams(window.location.search);
  const myParam = urlParams.get(errorMsgURL);
  if (myParam) {
    showMessageError(myParam);
  }
});

function getParameterByName(name, url) {
  if (!url) {
      url = window.location.href;
  }
  name = name.replace(/[\[\]]/g, '\\$&');
  var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
  results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return "";
  return decodeURIComponent(results[2].replace(/\+/g, ' '));
}

function checkSessionKey() {
  $.ajax({
      type: "GET",
      url: "/logincontext?sessionDataKey=" + getParameterByName("sessionDataKey") + "&relyingParty=" + getParameterByName("relyingParty") + "&tenantDomain=" + getParameterByName("tenantDomain"),
      success: function (data) {
          if (data && data.status == 'redirect' && data.redirectUrl && data.redirectUrl.length > 0) {
              window.location.href = data.redirectUrl;
          }
      },
      cache: false
  });
}

