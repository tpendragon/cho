# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe DataDictionary::FieldsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # MetadataField. As you add validations to MetadataField, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { 'label' => 'My Field', 'field_type' => 'numeric', 'requirement_designation' => 'optional', 'validation' => 'no_validation', 'multiple' => '0', 'controlled_vocabulary' => 'no_vocabulary', 'default_value' => 'blah', 'display_name' => 'blah', 'display_transformation' => 'no_transformation' }
  }

  let(:invalid_attributes) {
    { 'label' => 'My Field', 'field_type' => 'numeric', 'requirement_designation' => 'optional_invalid', 'validation' => 'no_validation', 'multiple' => '0', 'controlled_vocabulary' => 'no_vocabulary', 'default_value' => 'blah', 'display_name' => 'blah', 'display_transformation' => 'no_transformation' }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MetadataFieldsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context 'valid object created' do
    let!(:dictionary_field) { create_for_repository(:data_dictionary_field) }
    let(:title_field) { DataDictionary::Field.all.to_a.keep_if { |f| f.label == 'title' }.first }
    let(:reloaded_dictionary_field) { Valkyrie.config.metadata_adapter.query_service.find_by(id: dictionary_field.id) }

    describe 'GET #index' do
      it 'returns a success response' do
        get :index, params: {}, session: valid_session
        expect(response).to be_success
      end
    end

    describe 'GET #index.json' do
      render_views
      it 'returns json' do
        get :index, params: {}, session: valid_session, format: :json
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq("[{\"label\":\"title\",\"field_type\":\"string\",\"requirement_designation\":\"required_to_publish\",\"validation\":\"no_validation\",\"multiple\":true,\"controlled_vocabulary\":\"no_vocabulary\",\"default_value\":null,\"display_name\":null,\"display_transformation\":\"no_transformation\",\"url\":\"http://test.host/data_dictionary_fields/#{title_field.id}.json\"},{\"label\":\"abc123_label\",\"field_type\":\"date\",\"requirement_designation\":\"recommended\",\"validation\":\"no_validation\",\"multiple\":false,\"controlled_vocabulary\":\"no_vocabulary\",\"default_value\":\"abc123\",\"display_name\":\"My Abc123\",\"display_transformation\":\"no_transformation\",\"url\":\"http://test.host/data_dictionary_fields/#{dictionary_field.id}.json\"}]")
      end
    end

    describe 'GET #index.csv' do
      render_views
      it 'returns csv' do
        get :index, params: {}, session: valid_session, format: :csv
        expect(response.content_type).to eq('text/csv')
        expect(response.body).to eq("Label,Field Type,Requirement Designation,Validation,Multiple,Controlled Vocabulary,Default Value,Display Name,Display Transformation\ntitle,string,required_to_publish,no_validation,true,no_vocabulary,,,no_transformation\nabc123_label,date,recommended,no_validation,false,no_vocabulary,abc123,My Abc123,no_transformation\n")
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: dictionary_field.to_param }, session: valid_session
        expect(response).to be_success
        expect(assigns(:data_dictionary_field)).to be_a(DataDictionary::Field)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: dictionary_field.to_param }, session: valid_session
        expect(response).to be_success
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) {
          { 'label' => 'My Field', 'field_type' => 'text', 'requirement_designation' => 'required_to_publish', 'validation' => 'no_validation', 'multiple' => '0', 'controlled_vocabulary' => 'no_vocabulary', 'default_value' => 'new', 'display_name' => 'new display', 'display_transformation' => 'no_transformation' }
        }

        it 'updates the requested dictionary_field' do
          put :update, params: { id: dictionary_field.to_param, data_dictionary_field: new_attributes }, session: valid_session
          expect(response).to redirect_to(reloaded_dictionary_field)
          expect(reloaded_dictionary_field.multiple).to be_falsey
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: { id: dictionary_field.to_param, data_dictionary_field: invalid_attributes }, session: valid_session
          expect(response).to be_success
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested dictionary_field' do
        expect {
          delete :destroy, params: { id: dictionary_field.to_param }, session: valid_session
        }.to change(DataDictionary::Field, :count).by(-1)
      end

      it 'redirects to the data_dictionary_fields list' do
        delete :destroy, params: { id: dictionary_field.to_param }, session: valid_session
        expect(response).to redirect_to(data_dictionary_fields_url)
      end
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
      expect(assigns(:data_dictionary_field)).to be_a(DataDictionary::FieldChangeSet)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new MetadataField' do
        expect {
          post :create, params: { data_dictionary_field: valid_attributes }, session: valid_session
        }.to change(DataDictionary::Field, :count).by(1)
      end

      it 'redirects to the created dictionary_field' do
        post :create, params: { data_dictionary_field: valid_attributes }, session: valid_session
        expect(response).to redirect_to(DataDictionary::Field.all.to_a.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { data_dictionary_field: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end
end
