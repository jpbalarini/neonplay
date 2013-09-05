require 'spec_helper'

describe BarsController do

	let(:name) {'Bremen'}

	describe "#create" do
		let(:valid_params) { { :bar => { name: name } } }

		context "with valid params" do
			 it "creates the bar" do
		        post :create, valid_params 
		        response.should be_success
		        Bar.where(name: name).should exist
		     end

		     it "sets the token correctly" do
	        	post :create, valid_params
	        	response.should be_success
	        	Bar.where(name: name).first.token.should_not == ""
	         end
		end

		context "with error conditions" do
    
	      it "responds with error if name is already taken" do
	        FactoryGirl.create(:bar)
	        post :create, valid_params
	        response.response_code.should == 422
	        response.body.should == { :error => { :name => ["has already been taken"] }}.to_json
      	  end

      	end
	end

	describe "#songs" do

		context "with valid params" do
			 it "purchase the song" do			 	
			 	bar = FactoryGirl.create(:bar)	
			 	song = FactoryGirl.create(:song)		 	
			 	request.env["bar_token"] = bar.token
			 	post :songs, { id: bar.id, song_id: song.id }
	        	response.should be_success
			 end
		end
	end

	describe "#jukebox" do

		context "with valid params" do
			 it "play the song" do			 	
			 	bar = FactoryGirl.create(:bar)			 	
			 	request.env["bar_token"] = bar.token
			 	put :jukebox,  {id: bar.id, :jukebox => {url: 'http://0.0.0.0:9292', volume: 5}}
	        	response.should be_success
			 end
		end
	end

	describe "#jukebox_info" do

		context "with valid params" do
			 it "purchase the song" do					 	
			 	#bar = FactoryGirl.create(:bar)
			 	jukebox = FactoryGirl.create(:jukebox)		 				 	
			 	bar = jukebox.bar
			 	request.env["bar_token"] = bar.token
			 	get :jukebox_info,  {id: bar.id}
	        	response.should be_success
			 end
		end
	end

end
