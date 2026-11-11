# Dashboard

<!-- Generator: fill from the "Dashboard" interview topic. If the user doesn't want a dashboard yet, replace the placeholders with "Not built yet." After the Dashboard step builds one, document the real commands. -->

Web dashboard for {{PROJECT_NAME}}.

- **Framework:** {{default: Next.js}}
- **Data source:** Notehub API
- **Deployed at:** {{URL / not deployed}}

## Environment variables

Copy [`.env.example`](./.env.example) to `.env` (or the file your framework expects, such as `.env.local`) and fill in the values. Never commit the real file.

| Variable | Required | Description |
| --- | --- | --- |
| `NOTEHUB_PROJECT_UID` | Yes | Notehub project UID (`app:...`). |
| `NOTEHUB_PERSONAL_ACCESS_TOKEN` | Yes | Notehub personal access token, limited to this project. Server-side only: never expose it to the browser. |

To create the token, open the user menu in [Notehub](https://notehub.io), choose **API Access**, and click **Create New Token**. Set the scope to **Viewer Privileges in One Project** and pick this project. If the dashboard changes things in Notehub, such as environment variables, use **My Privileges in One Project** instead. Don't give a dashboard a token that can reach all of your projects.

## Run locally

```sh
{{e.g. npm install && npm run dev}}
```
