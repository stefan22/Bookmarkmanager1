feature 'User Management' do

  feature 'User signs up' do

    scenario 'when being a new user visiting the site' do
      expect { sign_up }.to change(User, :count).by(1)
      expect(page).to have_content('Welcome, alice@example.com')


      expect(User.first.email).to eq('alice@example.com')
    end


    scenario 'with a password that does not match' do
      expect { sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
      expect(current_path).to eq('/users')
      expect(page).to have_content('Sorry, there were the following problems with the form.')
    end


    scenario 'with an email that is already registered' do
      expect { sign_up }.to change(User, :count).by(1)
      expect { sign_up }.to change(User, :count).by(0)
      expect(page).to have_content('This email is already taken')
    end


    def sign_up(email = 'alice@example.com',
                password = 'oranges!',
                password_confirmation = 'oranges!')
      visit '/users/new'
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation
      click_button 'Sign up'
    end


  end


  feature 'User signs in' do

    before(:each) do
      User.create(email: 'test@test.com',
                  password: 'test',
                  password_confirmation: 'test')
    end

    scenario 'with correct credentials' do
      visit '/sessions/new'
      expect(page).not_to have_content('Welcome, test@test.com')
      sign_in('test@test.com', 'test')
      expect(page).to have_content('Welcome, test@test.com')
    end

    scenario 'with incorrect credentials' do
      visit '/sessions/new'
      expect(page).not_to have_content('Welcome, test@test.com')
      sign_in('test@test.com', 'wrong')
      expect(page).not_to have_content('Welcome, test@test.com')
    end

  end


  feature 'User signs out' do

    before(:each) do
      User.create(email: 'test@test.com',
                  password: 'test',
                  password_confirmation: 'test')
    end

    scenario 'while being signed in' do
      sign_in('test@test.com', 'test')
      click_button 'Sign out'
      expect(page).to have_content('Good bye!') # where does this message go?
      expect(page).not_to have_content('Welcome, test@test.com')
    end

  end

  feature 'Recover password' do

    scenario 'Requesting a password recovery token' do
      visit '/sessions/new'
      user = User.create(email: 'test@test.com', password: 'hello', password_confirmation:'hello')
      within('#password-recovery') do
        fill_in 'email', with: user.email
        click_button 'Recover password'
      end
      user = User.first(email:"test@test.com")
      expect(user.password_token).to be
    end

    # scenario 'Sending user password recovery token email' do
    #   visit '/sessions/new'
    #   user = User.create(email: 'test@test.com', password: 'hello', password_confirmation:'hello')
    #
    #   expect(User).to receive()
    #
    #   within('#password-recovery') do
    #     fill_in 'email', with: user.email
    #     click_button 'Recover password'
    #   end
    # end
  end

  def sign_in(email, password)
    visit '/sessions/new'
    within('#sign-in') do
      fill_in 'email', with: email
      fill_in 'password', with: password
      click_button 'Sign in'
    end
  end

end
