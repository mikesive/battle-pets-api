# README

## Api Architecture

### Projects

The Api consists of 3 different projects:
* An auth-api for managing user registration and auth
* A management-api that acts as an api gateway for the auth api, as well as manages battle pets and battles
* A set of workers to handle recruitment and battles

These can be found at:
* auth-api (https://github.com/mikesive/battle-pets-auth)
* management-api (https://github.com/mikesive/battle-pets-api)
* workers (https://github.com/mikesive/battle-pets-workers)

### Plumbing

There are two different queues that provide communication between the above-mentioned applications
* Redis is used by the management-api and the workers, to communicate back and forth. Each of those have a set of Sidekiq workers that read off of a queue specific to each project
* RabbitMQ is used for synchronous message processing between the management-api and the auth-api. I have used CarrotRpc (https://github.com/C-S-D/carrot_rpc) to implement Remote Procedure Calls for the different auth-api actions

## Api Documentation
**Note: All parameters are required unless otherwise specified**

**Note: Any actions with "(secure)" need to have a JWT in the X-Auth-Token request header or they will return a 401 error**

### Users
#### Create a user
Route: `POST /users`

Params: `{"user": {"username": "XXX", "password": "XXX"}}`

#### Update a user (secure)
Route: `PUT /users`

Params: `{"user": {"username": "XXX", "password": "XXX"}}`

**Requirement: Must have user key with either username or password, but not necessary to have both**

### Sessions
#### Create a session
Route: `POST /users`

Params: `{"user": {"username": "XXX", "password": "XXX"}}`

### BattlePets
#### Recruit a BattlePet (secure)
Route `POST /battle_pets`

Params: `{"battle_pet": { "name": "XXX", agility: <int(1..10)> }}`

**Requirements:**

* Name is required
* Other valid attributes are agility, intelligence, senses, strength
* Max number for any attribute is 10
* Invalid attributes will be ignored
* Valid attributes that are missing will be assumed to be 0
* After this is successful, the recruitment process will begin and the pet will be in a pending state
* You can track the pet recruitment by viewing the pet as shown in "Show a BattlePet"

#### Show a BattlePet (secure)
Route `GET /battle_pets/:id`

#### List User's BattlePets (secure)
Route `GET /battle_pets`

### Battles
#### Create a Battle (secure)
Route `POST /battles`

Params: `{"battle": { "battle_type": "XXX", contestant_ids: [x, x] }}`

**Requirements:**

* Valid battle_types are agility, intelligence, senses, strength
* contestant_ids must be an array of 2 ids
* At least one id must correspond to a pet that the user owns
* After this is successful, the battle process will begin and the battle will be in an incomplete state
* You can track the battle by viewing it as shown in "Show a Battle"

#### Show a Battle (secure)
Route `GET /battles/:id`

#### List User's Battles (secure)
Route `GET /battles`
