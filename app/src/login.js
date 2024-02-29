module.exports = {
    validateUser: (username, password) => {
        // login logic
        if(username === 'admin' && password === 'admin') {
            return true;
        }

        return false;
    },
    isUserLoggedIn: (req, res, next) => {
        // check if user is logged in
        let isLogged = Boolean(
            req.session &&
            req.session.username
        );

        if (isLogged) {
            next();
            return;
        }

        res.redirect('/login');
    }
};