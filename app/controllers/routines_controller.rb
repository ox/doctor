class RoutinesController < ApplicationController
  def show
    @routine = Routine.find(params[:id])
    @events = @routine.events
  end
  
  def destroy
    @routine = Routine.find(params[:id])
    stethoscope = @routine.stethoscope
    @routine.destroy
    
    respond_to do |format|
      format.html { redirect_to "/stethoscopes/#{stethoscope.id}" }
    end
  end
end