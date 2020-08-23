# README

### Notes

* We will be using the word libraries to unify GitHub repositories and GitLab projects.
* Authentication with Github is mandatory. Provide oauth token by setting ENV variable `GITHUB_OAUTH_TOKEN`.
* Pagination is out of scope for this assignment
* Model data is not validated. We could add dry-validation or active model if needed.
* API clients are bare minimum.
* VCR would have made things simpler but since this is dummy app is not worth the setup.

### Preparation

Github OAuth token is needed to run the app.

### Starting the app with docker

```
  GITHUB_OAUTH_TOKEN=token docker-compose up
```

App should be accessible at http://localhost:9292/libraries
