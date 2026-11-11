# Dashboard

<!-- Generator: fill from the "Dashboard" interview topic. If the user doesn't want a dashboard yet, replace the placeholders with "Not built yet." After building one (step 8), document the real commands. -->

Web dashboard for {{PROJECT_NAME}}.

- **Framework:** {{Next.js}}
- **Data source:** Notehub API
- **Deployed at:** {{URL / not deployed}}

## Environment variables

Copy [`.env.example`](./.env.example) to `.env` (or the file your framework expects, such as `.env.local`) and fill in the values. Never commit the real file.

| Variable | Required | Description |
| --- | --- | --- |
| `NOTEHUB_PROJECT_UID` | Yes | Notehub project UID (`app:...`). |
| `NOTEHUB_PERSONAL_ACCESS_TOKEN` | Yes | Personal access token from Notehub → Account Settings. Server-side only: never expose it to the browser. |

## Run locally

```sh
{{e.g. npm install && npm run dev}}
```
