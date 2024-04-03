<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendhost App</title>
</head>
<body>
    <h1>Welcome to My Trendhost App</h1>
    <div id="fb-root"></div>
    <button onclick="login()">Login with Trendhost</button>

    <script>
        function statusChangeCallback(response) {
            if (response.status === 'connected') {
                console.log('Logged in and authenticated');
                // Call backend to handle user authentication
                handleAuthResponse(response.authResponse);
            } else {
                console.log('Not authenticated');
            }
        }

        function checkLoginState() {
            FB.getLoginStatus(function(response) {
                statusChangeCallback(response);
            });
        }

        function login() {
            FB.login(function(response) {
                statusChangeCallback(response);
            }, { scope: 'email' });
        }

        window.fbAsyncInit = function() {
            FB.init({
                appId      : 'YOUR_TRENDHOST_APP_ID',
                cookie     : true,
                xfbml      : true,
                version    : 'v10.0'
            });
        };

        function handleAuthResponse(authResponse) {
            // Send authResponse to backend (PHP)
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
                    console.log('User authenticated on the server side');
                    // Redirect or display logged-in content
                }
            };
            xhr.open("POST", "backend.php", true);
            xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
            xhr.send(JSON.stringify(authResponse));
        };

        (function(d, s, id){
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) {return;}
            js = d.createElement(s); js.id = id;
            js.src = "https://connect.trendhost.net/en_US/sdk.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'trendhost-jssdk'));
    </script>
</body>
</html>
  
