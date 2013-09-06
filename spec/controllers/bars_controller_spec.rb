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

      it "should show correct output" do
        post :create, valid_params
        response.should be_success
        response.body.should == Bar.where(name: name).first.to_json
      end
    end

    context "with error conditions" do
      it "responds with error if name is already taken" do
        FactoryGirl.create(:bar)
        post :create, valid_params
        response.response_code.should == 422
        response.body.should == { :error => { :name => ["has already been taken"] }}.to_json
      end

      it "responds with error if request has no fields" do
        FactoryGirl.create(:bar)
        post :create
        response.response_code.should == 422
        response.body.should == { :error => { :name => ["Please enter a name"] }}.to_json
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

    context "with invalid params" do
      it "should return error" do
        bar = FactoryGirl.create(:bar)
        song = FactoryGirl.create(:song)
        request.env["bar_token"] = bar.token
        post :songs, { id: -1, song_id: song.id }
        response.response_code.should == 422
      end
    end

    context "with no auth" do
      it "should return not authorized" do
        bar = FactoryGirl.create(:bar)
        song = FactoryGirl.create(:song)
        post :songs, { id: bar.id, song_id: song.id }
        response.response_code.should == 401
      end
    end
  end


  describe "#jukebox" do
    context "with valid params" do
      it "play the song" do
        bar = FactoryGirl.create(:bar)
        request.env["bar_token"] = bar.token
        put :jukebox, {id: bar.id, :jukebox => {url: 'http://0.0.0.0:9292', volume: 5}}
        response.should be_success
      end
    end

    context "with invalid params" do
      it "should return error" do
        bar = FactoryGirl.create(:bar)
        request.env["bar_token"] = bar.token
        put :jukebox, {id: -1, :jukebox => {url: '', volume: 5}}
        response.response_code.should == 422
      end
    end

    context "with no auth" do
      it "should return not authorized" do
        bar = FactoryGirl.create(:bar)
        put :jukebox, {id: bar.id, :jukebox => {url: 'http://0.0.0.0:9292', volume: 5}}
        response.response_code.should == 401
      end
    end
  end


  describe "#jukebox_info" do
    context "with valid params" do
      it "purchase the song" do            
        #bar = FactoryGirl.create(:bar)
        jukebox = FactoryGirl.create(:jukebox)
        bar = jukebox.bar
        get :jukebox_info, {id: bar.id}
        response.should be_success
      end
    end

    context "with invalid params" do
      it "should return error" do  
        jukebox = FactoryGirl.create(:jukebox)
        bar = jukebox.bar
        get :jukebox_info, {id: -1}
        response.response_code.should == 422
      end
    end
  end


  describe "#add_song" do
    context "with valid params" do
      it "should add the song" do
        jukebox = FactoryGirl.create(:jukebox)
        bar = jukebox.bar
        song = jukebox.bar.songs.first
        post :add_song, {id: bar.id, song_id: song.id}
        response.should be_success
      end
    end

    context "with invalid params" do
      it "should return error" do  
        jukebox = FactoryGirl.create(:jukebox)
        bar = jukebox.bar
        song = jukebox.bar.songs.first
        post :add_song, {id: bar.id, song_id: -1}
        response.response_code.should == 422
      end
    end
  end


  describe "#jukebox_songs" do
    context "with valid params" do
      it "should list the bar's jukebox songs with 1 song. No repeat" do
        jukebox = FactoryGirl.create(:jukebox)
        bar = jukebox.bar
        song = jukebox.bar.songs.first
        post :add_song, {id: bar.id, song_id: song.id}

        get :jukebox_songs, {id: bar.id}
        response.should be_success

        songs = Array.new
        songs << song
        response.body.should == songs.to_json
      end

      it "should list the bar's jukebox songs with 2 songs. Repeat On" do
        jukebox = FactoryGirl.create(:jukebox_repeat)
        bar = jukebox.bar
        song = jukebox.bar.songs.first
        song2 = jukebox.bar.songs.second
        post :add_song, {id: bar.id, song_id: song.id}
        post :add_song, {id: bar.id, song_id: song2.id}

        get :jukebox_songs, {id: bar.id}
        response.should be_success

        songs = Array.new
        songs << song
        songs << song2
        response.body.should == songs.to_json
      end
    end

    context "with invalid params" do
      it "should return error" do  
        jukebox = FactoryGirl.create(:jukebox)
        bar = jukebox.bar
        get :jukebox_songs, {id: -1}
        response.response_code.should == 422
      end
    end
  end

end
