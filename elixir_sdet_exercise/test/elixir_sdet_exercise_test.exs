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

  def find_from_form do
    f_name = find_element(:name, "firstname")
    l_name = find_element(:name, "lastname")
    reg_email = find_element(:name, "reg_email__")
    pswd = find_element(:name, "reg_passwd__")
    gender_m = find_element(:id, "u_0_9")# not consistent. not sure if this is intended or a potential bug.
    gender_f = find_element(:id, "u_0_8")
    gender_c = find_element(:id, "u_0_a")
    submit_btn = find_element(:name, "websubmit")
    %{
      first: f_name, 
      last: l_name, 
      ph_email: reg_email, 
      pw: pswd, 
      gender_male: gender_m,
      gender_female: gender_f,
      gender_custom: gender_c, 
      submit: submit_btn
    }
  end

  def invalid_creds do
    find_element(:name, "email") |> fill_field("igarcia@vasttechsolutions.com")
    find_element(:name, "pass") |> fill_field(Faker.String.base64(10))
    click({:id, "loginbutton"})
  end

  def while(condition, function) do
    if condition == true do
      function.()
      while(condition, function)
    end
  end

  test "goes to facebook" do
    navigate_to "https://facebook.com"

    expectedTitle = "Facebook - Log In or Sign Up"
    eval = if page_title() == expectedTitle, do: "truthy", else: screenshot "facebook_page_load"
    
    assert eval
  end

  test "empty first name" do
    navigate_to "https://facebook.com"

    f_name = find_element(:name, "firstname")
    fill_field(f_name, Faker.Name.first_name())
    fill_field(f_name, "")
    click(f_name)

    eval = if element?(:class, "_5634"), do: "truthy", else: screenshot "empty_f_name"

    assert eval
  end

  test "empty last name" do
    navigate_to "https://facebook.com"

    l_name = find_element(:name, "lastname")
    fill_field(l_name, Faker.Name.last_name())
    fill_field(l_name, "")
    click(l_name)

    eval = if element?(:class, "_5634"), do: "truthy", else: screenshot "empty_l_name"

    assert eval
  end

  test "empty email/phone" do
    navigate_to "https://facebook.com"

    reg_email = find_element(:name, "reg_email__")
    fill_field(reg_email, "#{Faker.Pokemon.name}@example.com")
    fill_field(reg_email, "")
    click(reg_email)

    eval = if element?(:class, "_5634"), do: "truthy", else: screenshot "empty_email_phone"

    assert eval
  end

  test "empty password" do
    navigate_to "https://facebook.com"

    pw = find_element(:name, "reg_passwd__")
    fill_field(pw, Faker.String.base64())
    fill_field(pw, "")
    click(pw)

    eval = if element?(:class, "_5634"), do: "truthy", else: screenshot "empty_password"

    assert eval
  end

  test "symbols, numbers, unusual capitalization, repeating characters or punctuation for name" do
    navigate_to "https://facebook.com"
    
    form = find_from_form()
    fill_field(form[:first], "JoHn")
    fill_field(form[:last], "doesssYYYY!")
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    click(form[:gender_male])
  
    click(form[:submit])
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    
    expected_msg = "This name has certain characters that aren't allowed. "
    :timer.sleep(1500) # write function to wait for element 
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "not_allowed_characters"

    assert eval
  end

  test "characters from multiple languages for name" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], "аэыуо")
    fill_field(form[:last], "áéíó")
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    click(form[:gender_male])
  
    click(form[:submit])
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    
    expected_msg = "Names on Facebook can't have characters from more than one alphabet. "
    :timer.sleep(1500)
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "characters_multiple_alphabet"

    assert eval
  end

  test "using titles for name" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], "аэыуо")
    fill_field(form[:last], "áéíó")
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    click(form[:gender_male])
  
    click(form[:submit])
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    
    expected_msg = "Names on Facebook can't have characters from more than one alphabet. "
    :timer.sleep(1500)
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "title_name"

    assert eval
  end

  test "everyday life name" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], "words")
    fill_field(form[:last], "name")
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    click(form[:gender_male])
  
    click(form[:submit])
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    
    expected_msg = "We require everyone to use the name they use in everyday life, what their friends call them, on Facebook. "
    :timer.sleep(1500)
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "everyday_life_name"

    assert eval
  end

  @tag :not_implemented
  test "using offensive words of any kind as name" do
  ##TODO
   # "using words in place of name", using suggestive words of any kind as name", 
   # "using offensive words of any kind as name" all return same error
  end

  @tag :not_implemented
  test "using suggestive words of any kind as name" do
  ##TODO
  # "using words in place of name", using suggestive words of any kind as name", 
  # "using offensive words of any kind as name" all return same error
  end

  test "very long first name" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], "thisisaverylongfirstnamebutitshouldthrowanerror")
    fill_field(form[:last], "name")
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    click(form[:gender_male])
  
    click(form[:submit])
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    
    expected_msg = "First or last names on Facebook can't have too many characters. "
    :timer.sleep(1500)
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "long_first_name"

    assert eval
  end

  test "very long last name" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], "name")
    fill_field(form[:last], "thisisaverylonglastnamebutitshouldthrowanerror")
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    click(form[:gender_male])
  
    click(form[:submit])
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    
    expected_msg = "First or last names on Facebook can't have too many characters. "
    :timer.sleep(1500)
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "long_last_name"

    assert eval
  end

  test "invalid phone number" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], Faker.Name.first_name())
    fill_field(form[:last], Faker.Name.last_name())
    fill_field(form[:ph_email], "#{Faker.Phone.EnUs.extension(4)}")
   
    click(form[:submit])
    :timer.sleep(1500)
    click(form[:ph_email])

    expected_msg = "Please enter a valid mobile number or email address."
    eval = if visible_in_page?(~r/#{expected_msg}/), do: "truthy", else: screenshot "invalid_number"

    assert eval
  end
  
  test "invalid email prefix" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], Faker.Name.first_name())
    fill_field(form[:last], Faker.Name.last_name())
    fill_field(form[:ph_email], "email.@example.com")
   
    click(form[:submit])
    click(form[:ph_email])

    expected_msg = "Please enter a valid mobile number or email address."
    eval = if visible_in_page?(~r/#{expected_msg}/), do: "truthy", else: screenshot "invalid_email_prefix"

    assert eval
  end
  
  test "invalid email domain" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], Faker.Name.first_name())
    fill_field(form[:last], Faker.Name.last_name())
    fill_field(form[:ph_email], "abc@example..com")
   
    click(form[:submit])
    click(form[:ph_email])
   
    expected_msg = "Please enter a valid mobile number or email address."
    eval = if visible_in_page?(~r/#{expected_msg}/), do: "truthy", else: screenshot "invalid_email_domain"

    assert eval
  end

  @tag :not_implemented
  test "non matching emails" do
  ##TODO
  end

  test "non secure password" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], Faker.Name.first_name())
    fill_field(form[:last], Faker.Name.last_name())
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "1234567")
    click(form[:gender_male])
    click(form[:submit])
    
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    :timer.sleep(1500)
    expected_msg = "Please choose a more secure password. It should be longer than 6 characters, unique to you, and difficult for others to guess."
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "nonsecure_password"

    assert eval
  end

  test "password too short" do
    navigate_to "https://facebook.com"

    form = find_from_form()
    fill_field(form[:first], Faker.Name.first_name())
    fill_field(form[:last], Faker.Name.last_name())
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "S3cUr")
    click(form[:gender_male])
    click(form[:submit])
    
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    :timer.sleep(1500)
    expected_msg = "Your password must be at least 6 characters long. Please try another."
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "too_short_password"

    assert eval
  end

  test "phone number as password" do
    navigate_to "https://facebook.com"
    phone_num = "801555#{Faker.Phone.EnUs.extension(4)}"
    
    form = find_from_form()
    fill_field(form[:first], Faker.Name.first_name())
    fill_field(form[:last], Faker.Name.last_name())
    fill_field(form[:ph_email], phone_num )
    fill_field(form[:pw], phone_num)
    click(form[:gender_male])
    click(form[:submit])
    
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    :timer.sleep(1500)

    expected_msg = "Your mobile number cannot be your password. Passwords should be longer than 6 characters, unique to you and difficult for others to guess."
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "phone_number_as_password"

    assert eval
  end

  test "email as password" do
    navigate_to "https://facebook.com"
    email = "#{Faker.Pokemon.name}@gmail.com"
    
    form = find_from_form()
    email_confirm = find_element(:name, "reg_email_confirmation__")

    fill_field(form[:first], Faker.Name.first_name())
    fill_field(form[:last], Faker.Name.last_name())
    fill_field(form[:ph_email], email )
    fill_field(email_confirm, email)

    fill_field(form[:pw], email)
    click(form[:gender_male])
    click(form[:submit])
    
    confirm = find_element(:class, "layerConfirm")
    click(confirm)
    :timer.sleep(1500)

    expected_msg = "Your email cannot be your password. Passwords should be longer than 6 characters, unique to you and difficult for others to guess."
    
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "email_as_password"

    assert eval
  end

  @tag :not_implemented 
  test "male Gender selection" do
  ##TODO
  # not implemented since focus is on negative testing
  end

  @tag :not_implemented
  test "female Gender selection" do
  ##TODO
  # not implemented since focus is on negative testing
  end

  @tag :not_implemented
  test "custom Gender selection" do
  ##TODO
  #not implemented since focus is on negative testing
  end

  test "no pronoun selection in custom gender" do
    navigate_to "https://facebook.com"
    form = find_from_form()
    fill_field(form[:first], "words")

    fill_field(form[:last], "name")
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    click(form[:gender_custom])
  
    click(form[:submit])
    
    expected_msg = "Please select your pronoun."
    eval = if visible_in_page?(~r/#{expected_msg}/), do: "truthy", else: screenshot "no_pronoun_selected"

    assert eval
  end

  test "underage account creation" do
  navigate_to "https://facebook.com"
    form = find_from_form()
    fill_field(form[:first], Faker.Name.En.first_name())
    fill_field(form[:last], Faker.Name.En.last_name())
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    find_element(:css, "#month option[value='3']") |> click()
    find_element(:css, "#day option[value='1']") |> click()
    find_element(:css, "#year option[value='2010']") |> click()
    form[:gender_male] |> click()
    click(form[:submit])
  
    expected_msg = "Sorry, we are not able to process your registration."
    :timer.sleep(1500)
    eval = if visible_in_page?(~r/#{expected_msg}/), do: "truthy", else: screenshot "underage_account"

    assert eval
  end

  test "creating account as celebrity" do
  navigate_to "https://facebook.com"
    form = find_from_form()
    fill_field(form[:first], "Justin")
    fill_field(form[:last], "Bieber")
    fill_field(form[:ph_email], "801555#{Faker.Phone.EnUs.extension(4)}")
    fill_field(form[:pw], "weadsfasdf8523")

    find_element(:css, "#month option[value='3']") |> click()
    find_element(:css, "#day option[value='1']") |> click()
    find_element(:css, "#year option[value='1994']") |> click()
    form[:gender_male] |> click()

    click(form[:submit])
    expected_msg = "It seems like you're trying to create a profile for a celebrity. Learn more about our name policies, including how to let us know if this is the name you use in everyday life, what your friends call you."
    
    :timer.sleep(1500)
    eval = if visible_in_element?({:id, "reg_error_inner"}, ~r/#{expected_msg}/), do: "truthy", else: screenshot "celebrity_account"

    assert eval
  end

  @tag :not_implemented
  test "existing phone number" do
  ##TODO
  end

  @tag :not_implemented
  test "existing email" do
   ##TODO
  end
  
  test "different login page loads after x number of failures" do
    navigate_to "https://www.facebook.com/login/"
    invalid_creds()

    wrong_creds_msg = visible_in_page?( ~r/The password you’ve entered is incorrect. /)
   
    result = 
    if wrong_creds_msg do
     while(wrong_creds_msg, fn -> invalid_creds() end)
    else 
     visible_in_page?(~r/You are trying too often. Please try again later./)
    end
    
    assert result == true
  end
end
