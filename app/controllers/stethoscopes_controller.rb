class StethoscopesController < ApplicationController
  # GET /stethoscopes
  # GET /stethoscopes.xml
  def index
    @stethoscopes = Stethoscope.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stethoscopes }
    end
  end

  # GET /stethoscopes/1
  # GET /stethoscopes/1.xml
  def show
    @stethoscope = Stethoscope.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stethoscope }
    end
  end

  # GET /stethoscopes/new
  # GET /stethoscopes/new.xml
  def new
    @stethoscope = Stethoscope.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stethoscope }
    end
  end

  # GET /stethoscopes/1/edit
  def edit
    @stethoscope = Stethoscope.find(params[:id])
  end
  
  def ping
    @stethoscope = Stethoscope.find(params[:id])
    @stethoscope.get_status
    redirect_to :action => "show"
  end
  
  def add_routine
    @routine = Routine.create(:name => params[:routine][:name], :stethoscope_id => params[:id])
    @stethoscope = Stethoscope.find(params[:id])
    respond_to do |format|
      if @routine.save
        @routine.perform
        format.html { redirect_to @stethoscope, :notice => "Successfully added routine" }
      else
        format.html { redirect_to @stethoscope, :notice => "Unsucessfully added routine" }
      end
    end
  end
  
  # POST /stethoscopes
  # POST /stethoscopes.xml
  def create
    @stethoscope = Stethoscope.new(params[:stethoscope])
    
    #lets ping the server to make sure it all works
    @stethoscope.routines << Routine.new(:name => 'mem_stats', :stethoscope_id => @stethoscope.id)
    @stethoscope.routines << Routine.new(:name => 'hostname', :stethoscope_id => @stethoscope.id)
    @stethoscope.routines << Routine.new(:name => 'number_of_resque_processes', :stethoscope_id => @stethoscope.id)
    @stethoscope.routines << Routine.new(:name => 'hostname', :stethoscope_id => @stethoscope.id)
    @stethoscope.routines << Routine.new(:name => 'processes_summary', :stethoscope_id => @stethoscope.id)
    @stethoscope.routines << Routine.new(:name => 'server_load', :stethoscope_id => @stethoscope.id)
    @stethoscope.routines << Routine.new(:name => 'cpu_usage', :stethoscope_id => @stethoscope.id)

    respond_to do |format|
      if @stethoscope.save
        format.html { redirect_to(@stethoscope, :notice => 'Stethoscope was successfully created.') }
        format.xml  { render :xml => @stethoscope, :status => :created, :location => @stethoscope }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stethoscope.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stethoscopes/1
  # PUT /stethoscopes/1.xml
  def update
    @stethoscope = Stethoscope.find(params[:id])

    respond_to do |format|
      if @stethoscope.update_attributes(params[:stethoscope])
        format.html { redirect_to(@stethoscope, :notice => 'Stethoscope was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stethoscope.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stethoscopes/1
  # DELETE /stethoscopes/1.xml
  def destroy
    @stethoscope = Stethoscope.find(params[:id])
    @stethoscope.destroy

    respond_to do |format|
      format.html { redirect_to(stethoscopes_url) }
      format.xml  { head :ok }
    end
  end
end
