defmodule ElixirSdetExerciseTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()
 
  def screenshot(test) do
    File.mkdir_p "./test/failure_screenshots"
    file_name = "#{test}_#{:os.system_time(:millisecond)}"
    take_screenshot "test/failure_screenshots/#{file_name}.png"

    false
  end

  test "goes to facebook" do
    navigate_to "https://facebook.com"

    expectedTitle = "Facebook - Log In or Sign Up"
    eval = if page_title() == expectedTitle, do: "truthy", else: screenshot "facebook_page_load"
    
    assert eval
  end

  @tag :not_implemented
  test "Symbols, numbers, unusual capitalization, repeating characters or punctuation for name" do
  ##TODO
  end

  @tag :not_implemented
  test "Characters from multiple languages for name" do
  ##TODO
  end

  @tag :not_implemented
  test "using titles for name" do
  ##TODO
  end

  @tag :not_implemented
  test "using words in place of name" do
  ##TODO
  end

  @tag :not_implemented
  test "using offensive words of any kind as name" do
  ##TODO
  end

  @tag :not_implemented
  test "Using suggestive words of any kind as name" do
  ##TODO
  end

  @tag :not_implemented
  test "very long first name" do
  ##TODO
  end

  @tag :not_implemented
  test "very long last name" do
  ##TODO
  end

  @tag :not_implemented
  test "invalid phone number" do
  ##TODO
  end

  @tag :not_implemented
  test "invalid email" do
  #TODO
  end

  @tag :not_implemented
  test "non secure password" do
  ##TODO
  end

  @tag :not_implemented
  test "phone number as password" do
  ##TODO
  end

  @tag :not_implemented
  test "email as password" do
  #TODO
  end

  @tag :not_implemented 
  test "Male Gender selection" do
  ##TODO
  end

  @tag :not_implemented
  test "Female Gender selection" do
  ##TODO
  end

  @tag :not_implemented
  test "Custom Gender selction" do
  ##TODO
  end

  @tag :not_implemented
  test "underage account creation" do
  ##TODO
  end

  @tag :not_implemented
  test "creating account as celebrity" do
  ##TODO
  end

  @tag :not_implemented
  test "existing phone number" do
  ##TODO
  end

  @tag :not_implemented
  test "existing email" do
   ##TODO
  end
end
