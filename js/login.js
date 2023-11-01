const togglePassword = document.querySelector("#togglePassword");
const password = document.querySelector("#password");
const messageAlert = document.querySelector("#alertMessage");
const buttonCloseMessageAlert = document.querySelector("#btnCloseAlert");
const textMessageAlert = document.querySelector("#textAlerMessage");
const btnSubmit = document.querySelector("#btnSubmit");
const formSubmit = document.querySelector("#formSubmit");
const paramAuthFailureMsg = "authFailureMsg";
const paramAuthFailure = "authFailure";
const URL_FRONT = "https://localhost:9443";
const clientId = "OZfb2icUEXehApXC8UCaMlHwFXYa";
const redirectUri = "https://invexluiss.modyo.cloud/loginunico/jwt&scope=openid FolioInternet,CUI,CodigoAplicacion";


const hideMessageError = () =>  messageAlert.classList.add('hide');

togglePassword.addEventListener("click", function () {
  const type = password.getAttribute("type") === "password" ? "text" : "password";
  password.setAttribute("type", type);
  this.classList.toggle("bi-eye");
});

buttonCloseMessageAlert.addEventListener("click", function () {
  hideMessageError();
});

const showMessageError = (message) => {
  textMessageAlert.innerHTML = message;
  messageAlert.classList.remove('hide');
}

const modifyUrl = (msg) => {
  return `${URL_FRONT}/oauth2/authorize?response_type=code&client_id=${clientId}&redirect_uri=${redirectUri}&authFailureMsg=${msg}`;
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
  btnSubmit.disabled = true;

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
  formSubmit.submit();
  btnSubmit.disabled = false;
});


$(document).ready(function () {
  const urlParams = new URLSearchParams(window.location.search);
  const isAuthFailure = urlParams.get(paramAuthFailure);
  const isAuthFailureMsg = urlParams.get(paramAuthFailureMsg);

  if (isAuthFailure) window.location.href = modifyUrl(isAuthFailureMsg);
  if (isAuthFailureMsg) showMessageError(isAuthFailureMsg);
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

