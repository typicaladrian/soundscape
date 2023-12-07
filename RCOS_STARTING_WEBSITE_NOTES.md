# <u>Requirements</u>
## ** ENSURE ALL PREREQS ARE UP TO DATE **
- Windows 10
- WSL
- npm
- pip
- python3

# <u>Setting Up Workspace</u>
1. Clone Microsoft/Soundscape found at: https://github.com/microsoft/soundscape/tree/main/svcs/soundscape-authoring

# <u> Installing Requairements </u>
1. In a WSL/Ubuntu console, run:
    1. `sudo apt update`
    1. `sudo apt install nodejs npm`
    1. `sudo apt install -y python3-pip`
    1. `python3 -m pip install --upgrade pip`
    1. `sudo apt install curl`

# <u>Starting the Local Website</u>
## Part 1: Within the Backend
1. Navigate to the outer backend folder.
1. In the `/backend` folder, if there is not a `.venv` directory, run `python3 -m venv .venv`.
1. In a WSL terminal, run `pip install -r requirements.txt`.
1. In the `/backend` directory, rename `example.env` to simply `.env`.
1. In the .env file, make sure `ENV="local"` and `DJANGO_SETTINGS_MODULE="backend.settings.local"`.
1. In the .env file, set `ALLOWED_HOSTS` to `ALLOWED_HOSTS="*"`.
1. Set the `AZURE_MAPS_SUBSCRIPTION_KEY = ""` to a valid value. **Incorrectly setting and exporting this variable results in an authentication error when trying to load the website!**
1. **IMPORTANT STEP:** Correcty format the `.env` file!
    1. Get rid of spaces in each line before and after the `=` sign. Ex: Result for the first line should be `ENV="local"` **NOT** `ENV = "local"`.
    1. Evenly space every line with one blank line in between. Add a blank line at the end of the file.
    1. **IMPORTANT!!!** Ensure that the encoding of the .env file is set to **LF**. *On VSCode this can be set by opening up your .env file, and changing CRLF to LF on the bottom left corner.*
1. Create copies of this file in the same directory. They should be named `development.env`, `local.env`, and `production.env`.
1. From the .env file, export all variables...
    1. **Easiest method:** Export all variables using the provided script by running `. ./export_env_variables.sh` within an Ubuntu console.
    1. This can be done individually within an Ubuntu console. Ex: `export VARIABLE_LINE`.

## Part 2: Within the Frontend
1. Navigate to the frontend.
1. Run `npm install`
    1. If **over 8 warnings**, run `npm audit fix --force` until ~ 8 warnings.
1. Install TailwindCSS as follows:
    1. Run `npm install tailwindcss postcss autoprefixer postcss-cli` in WSL/Ubuntu console.
    1. Run `npx tailwindcss init` in WSL/Ubuntu console.
    1. Add the paths to your `tailwind.config.js` file
		```
        @type {import('tailwindcss').Config} */
		module.exports = {
  		  content: ["./src/**/*.{html,js}"],
  		  theme: {
    		    extend: {},
  		  },
  		  plugins: [],
		}
        ```
    1. Add the tailwind directories to `src/index.css`:
        ```
        @tailwind base;
		@tailwind components;
		@tailwind utilities;
        ```
	1. Run `npx tailwindcss -i ./src/index.css -o ./dist/output.css --watch` in WSL/Ubuntu console.
	    1. Exit with `ctrl-c` when build is done.
	1. In the head of `public/index.html`, add `<link href="/dist/output.css" rel="stylesheet">`.
	1. You can test functionality by adding this block to a rendered area in a component:
        ``` 
		<h1 class="text-3xl font-bold underline">
    		  Hello world!
  		</h1>
        ```
1. Run `npm run build`

## Part 3: Within the Backend
1. Navigate to the outer backend folder. 
1. Run `python3 manage.py runserver`

# <u>Fixing Authentication Errors When Loading Page</u>
## Part 1: Within `svcs\soundscape-authoring\backend\backend\middleware\UserAllowlistMiddleware.py`
1. Comment out the `if user_permissions == None:` if statement block.
1. Comment out the `if user_permissions.allow_app == False:` if statement block.
1. Replace the `user_email = request.aad_user['email'].lower()` line to `user_email = "asdasdasd"` (or any random string). 
1. In the `svcs\soundscape-authoring\backend` create a `/.auth` folder.
    1. In the new `/.auth` folder, create a `me.json` file.
    1. In the new `me.json` file, add this code:
    ```
    [
        {
        "user_claims": [
            {
                "typ": "http://schemas.microsoft.com/identity/claims/objectidentifier",
                "val": "123vhjvjh45"
            },
            {
                "typ": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress",
                "val": "users@example.com" 
            },
            {
                "typ": "name",
                "val": "John Doe" 
            },
            {
                "typ": "preferred_username",
                "val": "johndoe" 
            }
        ],
             "id_token": "some_id_token_value"
        }
    ]
    ```
1. Within the `.env` file, there is a `X_MS_TOKEN_AAD_ID_TOKEN` variable. This variable must be set to a key which is unique to you and will be generated when you sign up on the Soundscape Community website **(make sure to never commit this value)**.