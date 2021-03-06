Neonplay app
==============
Some examples using curl. Ids may be different.
Two files must be created for correct execution. Database.yml and local_env.yml (under /config). The second file stores environmental variables.
To create and initialize database run:
```
rake db:setup
```

Example local_env.yml file
```
# Token used for admin authentication
# Available as ENV["ADMIN_TOKEN"]
ADMIN_TOKEN: 'ThisIsNeonPlayToken'
NEONPLAY_URL: 'http://localhost:3000'
```

Create song
--------------
```
curl --data "song[title]=Days are Forgotten&song[artist]=Kasabian&song[album]=Velociraptor&song[price]=0.99" --header "admin_token: ThisIsNeonPlayToken" http://localhost:3000/songs
```
```
curl --data "song[title]=Something&song[artist]=The Beatles&song[album]=One&song[price]=2.99" --header "admin_token: ThisIsNeonPlayToken" http://localhost:3000/songs
```
```
curl --data "song[title]=Don't Look Back In Anger&song[artist]=Oasis&song[album]=Morning Glory&song[price]=1.00" --header "admin_token: ThisIsNeonPlayToken" http://localhost:3000/songs
```

Create bar
--------------
```
curl --data "bar[name]=Moe's Bar" http://localhost:3000/bars
```
```
curl --data "bar[name]=Bremen" http://localhost:3000/bars
```

List songs
--------------
```
curl --header "admin_token: ThisIsNeonPlayToken" --data "page=1&limit=2" -X GET http://localhost:3000/songs
```
```
curl --header "bar_token: 8093c64331ab2486" --data "page=1&limit=2" -X GET http://localhost:3000/songs
```

Songs on sale
--------------
```
curl --header "admin_token: ThisIsNeonPlayToken" --data "page=2&limit=1" -X GET http://localhost:3000/songs/on_sale
```
```
curl --header "bar_token: 8093c64331ab2486" --data "page=2&limit=1" -X GET http://localhost:3000/songs/on_sale
```

Buy songs for a bar
--------------
```
curl --data "song_id=6" --header "bar_token: 8093c64331ab2486" http://localhost:3000/bars/2/songs
```

Set bar's jukebox
--------------
```
curl --header "bar_token: 8093c64331ab2486" -X PUT -d "jukebox[url]=http://0.0.0.0:9292&jukebox[volume]=5&jukebox[repeat]=true" http://localhost:3000/bars/2/jukebox
```

Get bar's jukebox info
--------------
```
curl http://localhost:3000/bars/2/jukebox
```

Add song to bar's jukebox
--------------
```
curl --data "song_id=6" http://localhost:3000/bars/2/jukebox/songs
```
```
curl --data "song_id=8" http://localhost:3000/bars/2/jukebox/songs
```

Get a list of the songs from the bar's jukebox
--------------
```
curl --data "page=2&limit=1" -X GET http://localhost:3000/bars/2/jukebox/songs
```