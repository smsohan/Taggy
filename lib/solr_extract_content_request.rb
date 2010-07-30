class SolrExtractContentRequest < Solr::Request::Select

  def initialize(file_path)
    params = {
      'extractOnly' => true,
      'extractFormat' => 'text',
      'ext.resource.name' => file_path,
      'stream.file' => file_path,
      'wt' => 'ruby'      
    }        
    super(nil,params)
    Rails.logger.debug "SOLR EXTRACT CONTENT REQUEST WITH PARAMS = #{params.inspect}"
  end
 
  def handler
    'update/extract'                                                   
  end
end