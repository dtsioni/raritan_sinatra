# Raritan
## Five Point Oh - Score API - Version 1

###### Namespace: /fpo/1

### POST /:school/:department/:professor
* Creates a new professor (unless it exists)
  * Will create a new school and department as well if they are not found
  * Matches names with approximately correct ones
    * D Tsioni will match with Daniel Tsioni, etc
* Status 400 if any of the params are malformed
* Status 501 if there is an ambiguity in professor name
* Status 201 if a new professor is created
* Status 200 if the professor already exists (and isn't created)

### POST /:school/:department/:professor/scores
* Takes a JSON object from the params of the format:
    { score: {easiness: 1, helpfulness: 1, clarity: 1, interesting: 1, work: 1, organization: 1, pacing: 1}, user_id: X}
    * user_id is chrome user id
* Attempts to match professor name with preexisting professors
* Will create a new professor if that professor isn't found
* Status 400 if any of the params are malformed
* Status 501 if there is an ambiguity in professor name
* Status 201 if a new score is created
* Status 200 if the user already voted for this professor, and their old score is updated
* Returns a success message

### GET /:school/:department/professors
* Returns a list of all professors in the given department, in the format:
  { professors: ["...", "..."] }
  
### GET /:school/departments
* Returns a list of all the departments in the given school, in the format:
  { departments: ["...", "..."] }
