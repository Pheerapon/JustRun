# Setup HASURA

One-click link below to setup hasura. (See more at setup clip)

<https://heroku.com/deploy?template=https://github.com/hasura/graphql-engine-heroku>

Add `HASURA_GRAPHQL_ADMIN_SECRET` in `Config Vars` of heroku app's setting page, then restart app.

## Import/Export metadata

Open file `hasura/hasura-2.0.3/metadata/databases/databases.yaml`, edit line 5 `database_url`,  
replace `<your-postges-database-url>` with your `DATABASE_URL` get in `Config Vars` of heroku app's setting page,

example:

```yaml
- name: default
  kind: postgres
  configuration:
    connection_info:
      database_url: postgres://xxx:xxx@xxx.compute-1.amazonaws.com:5432/xxx
      isolation_level: read-committed
      pool_settings:
        connection_lifetime: 600
        idle_timeout: 180
        max_connections: 15
        retries: 1
      use_prepared_statements: true
  tables: "!include default/tables/tables.yaml"
```

Install hasura cli, <https://hasura.io/docs/latest/graphql/core/hasura-cli/install-hasura-cli.html>.  
Don't forget upgrade cli to 2.0.3 version.  
Below is MacOS example:

```powershell
curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

sudo hasura update-cli --version v2.0.3
```

Then execute below commands, remember that replace `http://another-graphql-instance.hasura.app` with your server link.  
And admin secret is `HASURA_GRAPHQL_ADMIN_SECRET`.  
Reference: <https://hasura.io/docs/latest/graphql/core/migrations/migrations-setup.html#step-7-apply-the-migrations-and-metadata-on-another-instance-of-the-graphql-engine>

```sh
hasura migrate apply --database-name default --endpoint http://another-graphql-instance.hasura.app --admin-secret "<admin-secret>"

hasura metadata apply --endpoint http://another-graphql-instance.hasura.app --admin-secret "<admin-secret>"

hasura metadata reload --endpoint http://another-graphql-instance.hasura.app --admin-secret "<admin-secret>"
```

## Deploy firebase function

Open firebase console, create new project.

Install Firebase cli.  
<https://firebase.google.com/docs/cli>

Update Firebase billing plans to Blaze.

Go to realtime database, create new one, update rule like below

```json
{
  "rules": {
    "metadata": {
      "$uid": {
        ".read": "auth != null && auth.uid == $uid"
      }
    }
  }
}
```

Go to Authentication, enable it, enable login with google also.

Open terminal, go to hasura directory.

```sh
firebase login
```

```sh
firebase projects:list
```

Enable Cloud Build API for your firebase project

```sh
firebase deploy --only functions --project <your-project-id>
```

Update hasura config HASURA_GRAPHQL_JWT_SECRET with value below.  
Don't forget change your firebase project id.

```json
{
  "jwk_url": "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com",
  "audience": "<your-project-id>",
  "issuer": "https://securetoken.google.com/<your-project-id>"
}
```

That's all. Now you can update `<your-project-directory>/lib/common/graphql/config.dart`, then run app with Android Studio, XCode or VSCode.
