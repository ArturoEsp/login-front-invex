<%--
  ~ Copyright (c) 2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~ WSO2 Inc. licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file except
  ~ in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<%@ page import="org.apache.cxf.jaxrs.client.JAXRSClientFactory" %>
<%@ page import="org.apache.cxf.jaxrs.provider.json.JSONProvider" %>
<%@ page import="org.apache.cxf.jaxrs.client.WebClient" %>
<%@ page import="org.apache.http.HttpStatus" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.client.SelfUserRegistrationResource" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.AuthenticationEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.bean.ResendCodeRequestDTO" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.bean.UserDTO" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="javax.ws.rs.core.Response" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isSelfSignUpEPAvailable" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isRecoveryEPAvailable" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isEmailUsernameEnabled" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.getServerURL" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="org.wso2.carbon.base.ServerConfiguration" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.EndpointConfigManager" %>

<jsp:directive.include file="includes/init-loginform-action-url.jsp"/>

<%
    String emailUsernameEnable = application.getInitParameter("EnableEmailUserName");
    Boolean isEmailUsernameEnabled = false;

    if (StringUtils.isNotBlank(emailUsernameEnable)) {
        isEmailUsernameEnabled = Boolean.valueOf(emailUsernameEnable);
    } else {
        isEmailUsernameEnabled = isEmailUsernameEnabled();
    }
%>

<script>
    function goBack() {
        window.history.back();
    }
    
    // Handle form submission preventing double submission.
    $(document).ready(function(){
        $('#loginForm').preventDoubleSubmission(); // Checar esta funcion el día de mañana
    });
</script>

<form class="ui large form" action="<%=loginFormActionURL%>" method="post" id="loginForm">
    <% if (Boolean.parseBoolean(loginFailed)) { %>
    <div class="ui visible negative message" id="error-msg"><%= errorMessage %></div>
    <% } else { %>
        <div class="ui visible negative message" style="display: none;" id="error-msg"></div>
    <% } %>

        <div class="field">
            <div class="ui fluid left icon input">
                <input
                    type="text"
                    id="usernameUserInput"
                    value=""
                    name="usernameUserInput"
                    tabindex="1"
                    placeholder="Usuario"
                    required>
                <i aria-hidden="true" class="user icon"></i>
                <input id="username" name="username" type="hidden" value="<%=username%>">
            </div>
        </div>
        <div class="field">
            <div class="ui fluid left icon input">
                <input
                    type="password"
                    id="password"
                    name="password"
                    value=""
                    autocomplete="off"
                    tabindex="2"
                    placeholder="Contraseña">
                <i aria-hidden="true" class="lock icon"></i>
            </div>
        </div>

    <input type="hidden" name="sessionDataKey" value='<%=Encode.forHtmlAttribute
            (request.getParameter("sessionDataKey"))%>'/>


    <div class="ui two column stackable grid">
        <div class="column mobile center aligned tablet right aligned computer right aligned buttons tablet no-margin-right-last-child computer no-margin-right-last-child">
            <button
                type="button"
                id="btnSubmit"
                class="ui primary large button"
                tabindex="4"
                role="button">
                Ingresar
            </button>
        </div>
    </div>
</form>
