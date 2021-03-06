Feature: Trello boards api features

  #GET
  Scenario: Retrieving boards list
    Given Create one board name 'new name'
    Given Set base URI 'https://api.trello.com/1'
    Given Set key and token
    When Send get request to endpoint '/members/me/boards'
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key 'name' has item 'new name'

  @RemoveAllBoards
  Scenario: Retrieving boards list when boards list is empty
    Given Set base URI 'https://api.trello.com/1'
    Given Set key and token
    When Send get request to endpoint '/members/me/boards'
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key 'id' is empty

  Scenario: Receive requested board's body field
    Given Create one board name 'new name'
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set base path '/name'
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key '_value' is 'new name'

  @CreateBoard
  Scenario: Get board actions and limit record to one
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set base path '/actions/?limit=1'
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "id" has size 1

  @CreateBoard
  Scenario: Get board plugins
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set base path '/boardPlugins'
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "idPlugin" is not null

  @CreateBoard
  Scenario: Get information about board is starred
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set query parameter 'fields' and value 'id'
    Given Set query parameter 'boardStars' and value 'mine'
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "boardStars" is empty

  @CreateBoard
  Scenario: Get available cards on the board
    Given Create a card with name "New card added"
    Given Create a card with name "Other card"
    Given Create a card with name "Another card"
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set base path '/cards'
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "name" has item "New card added"

  @CreateBoard
  Scenario: Get only closed card on the board
    Given Create a card with name "New name"
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set base path '/cards/closed'
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "name" is empty

  @CreateBoard
  Scenario: Get card from the board by card id
    Given Create a card with name "Previous card"
    Given Create a card with name "New card added"
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set base path '/cards'
    Given Set base path card id
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "name" is "New card added"

  @CreateBoard
  Scenario: Get boards all of checklist available
    Given Create a card with name "Card"
    Given Create a checklist with name "New checklist" on the card
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set base path '/checklists'
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "name" has item "New checklist"

  @CreateBoard
  Scenario: Get custom fields from board
    Given Enable custom field on board
    Given Create custom field dropdown list on board
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path "/boards"
    Given Set base path board id
    Given Set base path '/customFields'
    Given Set key and token
    When Send get request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "name" has item "My dropdown list"
    And Response body key "options.value.text[0]" has item "First"

  @CreateBoard
  Scenario: Update board name to update name
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path board id
    Given Set query parameter 'name' and value 'updated name'
    Given Set key and token
    When Send put request
    Then Status code should be 200
    And Content type should be 'application/json; charset=utf-8'
    And Status line should be 'HTTP/1.1 200 OK'
    And Response body key 'name' is 'updated name'

  @CreateBoard @RegisterTextParser
  Scenario: Make actions on the board when give wrong board id
    Given Set base URI 'https://api.trello.com/1'
    Given Set base path '/boards'
    Given Set base path '/anErrorId'
    Given Set query parameter 'name' and value 'updated name'
    Given Set key and token
    When Send put request
    Then Status code should be 400
    And Status line should be 'HTTP/1.1 400 Bad Request'
    And Content type should be 'text/plain; charset=utf-8'
    And Response body text is 'invalid id'

  #POST
  @CreateBoard
  Scenario: Enable voting plugin on board
    Given Set base URI 'https://api.trello.com/1'
    Given Set request content type text
    Given Set base path '/boards'
    Given Set base path board id
    Given Set base path '/boardPlugins'
    Given Set query parameter voting plugin id
    Given Set key and token
    When Send post request
    Then Status code should be 200
    And Status line should be 'HTTP/1.1 200 OK'
    And Content type should be 'application/json; charset=utf-8'
    And Response body key "idPlugin" is not null
    And Response body key "idBoard" is not null