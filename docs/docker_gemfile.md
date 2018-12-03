## Building Images for Development & Production

### 1. Development

##### 1.1 Prefix

Rebuilding your dev image is *only* necessary when changing your **Gemfile** or **Gemfile.lock**. Almost all file changes are automatically loaded. The exceptions, such as initializer files can be manually reloaded by redeploying your stack. (1.3.2)

##### 1.2 Build the dev image

```
docker build . -t registry.safing.network/dev/stamp
```

**docker-compose.yml** depends on that image and will *always* pull the image from safing.network, even when there is a newer build version locally.

##### 1.3.1 Push image

So simply push your local image:

```
docker push registry.safing.network/dev/stamp
```

##### 1.3.2 Restart docker stack

to then successfully restart your server:

```
docker stack deploy stamp -c docker-compose.yml
```

##### 1.4 Update Gemfile.lock

This is necessary to lock gem at specific versions even for production! So go into docker:

```
docker exec -ti $(docker ps | grep stamp_web.1. | cut -d" " -f1) /bin/bash
```

And run

```
bundle
```

As docker already runs on the correct image with the newly installed gems, this will simply save the new status in **Gemfile.lock**

### 2. Production

##### 2.1 Build the server image

```
docker build . -t registry.safing.network/server/stamp -f Dockerfile.production
```

**Dockerfile.production** is almost a duplicate of **Dockerfile**. The differences are, we set `RAILS_ENV` & `RACK_ENV` to *production* and we run `bundle install --without development test`. This way we skip installing a lot of gems which are not used in production.

**The difference:**

> Development: `Bundle complete! ... 145 gems now installed.`  
> Production: `Bundle complete! ... 90 gems now installed.`

##### 2.2 Deploy

After building the image, push it to safing.network. Then `ssh` to the server, `pull` the image and deploy your docker stack via the remote compose file.
