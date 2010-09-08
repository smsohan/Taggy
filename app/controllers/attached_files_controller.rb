class AttachedFilesController < ApplicationController
  def show
    @attached_file = AttachedFile.find(params[:id])
    send_file @attached_file.path
  end

end
