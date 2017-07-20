# README

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
