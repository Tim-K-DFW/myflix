class LinesController < ApplicationController

  def show      # shows queue, including controls to update it
    @queue = current_user.lines.sort_by { |k| k[:priority] }
  end


  def update

  end

end