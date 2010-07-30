class SolrExtractContentResponse < Solr::Response::Ruby
  def file_content file_name
    @data[file_name]
  end
end