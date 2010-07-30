class SolrCellRequest < Solr::Request::Select
  def initialize(doc, file_name, id)
    params = {
      # 'ext.idx.attr' => false,        # don't index any attributes, unless explicitly mapped
      'ext.def.fl' => 'text_t',        # all text extracted goes to text_t (since it is a stored field, for highlighting)
      'ext.ignore.und.fl' => true,      # ignore all undefined fields
      'ext.map.title' => 'title_t',
      'ext.resource.name' => file_name, # TIKA-154 workaround
      'stream.file' => file_name,
      'literal.id' => id
    }
    
    doc.each do |f|
      params["literal.#{f.name}"] = f.value
      if f.boost
        params["boost.#{f.name}"] = f.boost
      end
    end
    
    
    super(nil,params) 
    # super(params) 
  end
 
  def handler
    'update/extract'
  end
end