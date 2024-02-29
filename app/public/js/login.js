function login() {
    var username = document.getElementsByName('username')[0].value;
    var password = document.getElementsByName('password')[0].value;
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/login', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({username, password}));
    xhr.onreadystatechange = function() {
        console.log(xhr.readyState, xhr.status);
        if (xhr.readyState == 4 && xhr.status == 200) {
            var response = JSON.parse(xhr.responseText);
            console.log(response);
            if (response.success) {
                window.location.href = '/me';
            } else {
                alert('Login failed');
            }
        }
    }
}