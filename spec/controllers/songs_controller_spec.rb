require 'spec_helper'

describe SongsController do

	let(:title) {'Days are Forgotten'}
	let(:artist) {'Kasabian'}
	let(:album) {'Velociraptor'}
	let(:price) {'0.99'}

	describe "#create" do
		let(:valid_params) { { :song => { title: title, artist: artist, album: album, price: price } } }

		context "with valid params" do
			 it "creates the song" do
			 	request.env["admin_token"] = 'ThisIsNeonPlayToken'
		        post :create, valid_params 
		        response.should be_success
		        Song.where(title: title, artist: artist, album: album ).should exist
		     end

		     it "sets the price correctly" do
		     	request.env["admin_token"] = 'ThisIsNeonPlayToken'
	        	post :create, valid_params
	        	response.should be_success
	        	Song.where(title: title, artist: artist, album: album ).first.price.to_s.should == price
	         end
		end

		context "with error conditions" do
    
	      it "responds with error  if title is already taken" do
	        FactoryGirl.create(:song)
	        request.env["admin_token"] = 'ThisIsNeonPlayToken'
	        post :create, valid_params
	        response.response_code.should == 422
	        response.body.should == { :title => ["has already been taken"] }.to_json
      	  end

      	end
	end

	describe "#index" do
		context "with valid params" do
			 it "list all songs" do		
			  	song = FactoryGirl.create(:song)
			 	request.env["admin_token"] = 'ThisIsNeonPlayToken'
			 	get :index
			 	response.should be_success
			 	songs = Array.new
			 	songs << song
			 	response.body.should == songs.to_json
			 end
		end
	end

	describe "#on_sale" do 
		context "with valid params" do
			it "get on sale song" do
				song = FactoryGirl.create(:song)
			 	request.env["admin_token"] = 'ThisIsNeonPlayToken'
			 	get :index
			 	response.should be_success
			 	songs = Array.new
			 	songs << song
			 	response.body.should == songs.to_json
			end
		end
	end

end
