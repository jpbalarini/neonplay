require 'spec_helper'

describe SongsController do

  let(:title) {'Days are Forgotten'}
  let(:artist) {'Kasabian'}
  let(:album) {'Velociraptor'}
  let(:price) {'0.99'}

  describe "#create" do
    let(:valid_params) { { :song => { title: title, artist: artist, album: album, price: price } } }
    let(:invalid_params) { { :song => { title: "Another song", artist: artist, album: album, price: -1.00 } } }

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

      it "should show correct output" do
        request.env["admin_token"] = 'ThisIsNeonPlayToken'
        post :create, valid_params
        response.should be_success
        response.body.should == Song.where(title: title, artist: artist, album: album ).first.to_json
      end
    end

    context "with error conditions" do
      it "responds with error if title is already taken" do
        FactoryGirl.create(:song)
        request.env["admin_token"] = 'ThisIsNeonPlayToken'
        post :create, valid_params
        response.response_code.should == 422
        response.body.should == { :title => ["has already been taken"] }.to_json
      end

      it "responds with error if price is negative" do
        FactoryGirl.create(:song)
        request.env["admin_token"] = 'ThisIsNeonPlayToken'
        post :create, invalid_params
        response.response_code.should == 422
        response.body.should == { :price => ["Price must be greater than 0"] }.to_json
      end
    end

    context "without admin authentication"
      it "responds with not authorized" do
        post :create, valid_params
        response.response_code.should == 401
      end
  end

  describe "#index" do
    context "with valid params" do
      it "list all songs. Admin authentication" do   
        song = FactoryGirl.create(:song)
        request.env["admin_token"] = 'ThisIsNeonPlayToken'
        get :index
        response.should be_success
        songs = Array.new
        songs << song
        response.body.should == songs.to_json
      end

      it "list all songs. Bar owner authentication" do
        bar = FactoryGirl.create(:bar)
        request.env["bar_token"] = bar.token
        get :index
        response.should be_success
        response.body.should == Song.all.to_json
      end
    end
  end

  describe "#on_sale" do 
    context "with valid params. Admin authentication" do
      it "get on sale song" do
        song = FactoryGirl.create(:song)
        request.env["admin_token"] = 'ThisIsNeonPlayToken'
        get :on_sale
        response.should be_success
        songs = Array.new
        songs << song
        response.body.should == songs.to_json
      end
    end

    context "with valid params. Bar owner authentication" do
      it "get on sale song" do
        bar = FactoryGirl.create(:bar_2)
        request.env["bar_token"] = bar.token
        get :on_sale
        response.should be_success
        response.body.should == Song.where(["price <= ?", 1.00]).to_json
      end
    end
  end

end
