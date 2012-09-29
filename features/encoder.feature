Feature: Interactive Encoder
 
  As user of the interactive_encoder.rb command line tool
  I want to be sure that my tool works.

  @posix
  Scenario: Run default encoder
    When I run `interactive_encoder.rb` interactively
    And I type "Word"
    Then the output should contain "Word"

  @posix
  Scenario: Run identity encoder 
    When I run `interactive_encoder.rb identity` interactively
    And I type "Word"
    Then the output should contain "Word"

  @posix
  Scenario: Run rot13 encoder 
    When I run `interactive_encoder.rb rot13` interactively
    And I type "Word"
    Then the output should contain "Worq"

  @posix
  Scenario: Run an unsupported encoder 
    When I run `interactive_encoder.rb unsupported`
    Then the output should contain "No such encoder: unsupported"
