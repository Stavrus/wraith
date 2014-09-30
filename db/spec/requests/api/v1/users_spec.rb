# require 'spec_helper'

# describe Api::V1::UsersController do
#   describe 'POST #register' do

#     context 'when user does not exist' do

#       it 'renders the page with error' do
#         post api_v1_users_register_path
#         expect(response.status).to eq(422)
#       end

#     end

#     context 'when user is incorrect' do

#       before(:each) do
#         user = User.make!
#         sign_in user
#       end

#       it 'renders the page with error' do
#         post api_v1_users_register_path
#         expect(response.status).to eq(422)
#       end

#     end

#   end
# end