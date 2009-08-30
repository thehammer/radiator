require 'betabrite_writer'

class BetabriteController < ApplicationController

  def radiate
    node = params[:node] || '1'
    color = params[:color] || '0000FF'
    message = params[:message]

    BetabriteWriter.display(node, message, color)
  end
end