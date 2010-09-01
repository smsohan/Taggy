require 'test_helper'

class AttachedFileTest < ActiveSupport::TestCase
  should belong_to :project
  should belong_to :user_story
  should belong_to :message
  
  context 'fon an uploaded attachment' do
    
    setup  do
      @attached_file = AttachedFile.new
      StringIO.open("test content") do |file_data|
        file_data.original_filename = 'test.txt'
        file_data.content_type = 'text/plain'
        @attached_file.file = file_data
      end 
      @attached_file.save!
    end
    
    
    # should 'get the contents from solr' do
    #   dummy_file = nil
    #   ActsAsSolr::Post.expects(:execute).returns(dummy_file)
    #   dummy_file.expects(:file_content).with('test.txt').returns('test content')
    #   @attached_file.extract_content!
    #   assert 'test content', @attached_file.content
    # end
    
    should 'return the right url' do
      assert @attached_file.url =~ /attached_files\/#{@attached_file.id}/
    end
    
    should 'return the right file name' do
      assert_equal 'test.txt', @attached_file.name
    end
    
    should 'return the path' do
      assert_equal "#{Rails.root}/public/system/attached_files/#{@attached_file.id}/test.txt", @attached_file.path
    end
    
    teardown do
      # Mocha::Mockery.instance.stubba.unstub_all
    end
    
  end
  
  
end
