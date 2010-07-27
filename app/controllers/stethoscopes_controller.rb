class StethoscopesController < ApplicationController
  before_filter :authenticate
  
  
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
    @routines = @stethoscope.routines

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
    @stethoscope.save
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
  
  def duplicate
    @copy_me = Stethoscope.find(params[:id])
    @new_guy = Stethoscope.new(:server => @copy_me.server, :description => @copy_me.description)
    
    @copy_me.routines.each do |routine|
      @new_guy.routines << Routine.new(:name => routine.name, :stethoscope_id => @new_guy.id)
    end
    
    respond_to do |format|
      if @new_guy.save
        format.html { redirect_to edit_stethoscope_path(@new_guy)}
      else
        format.html { redirect_to root}
      end
    end
  end
  
  # POST /stethoscopes
  # POST /stethoscopes.xml
  def create
    @stethoscope = Stethoscope.new(params[:stethoscope])
    
    #lets ping the server to make sure it all works
    
    %w[mem_stats hostname number_of_resque_processes processes_summary server_load cpu_usage].each do |task|
      routine = Routine.new(:name => task, :stethoscope_id => @stethoscope.id)
      routine.events << Event.new(:status => 4, :returned => {'Notice' => "server called #{@stethoscope.server} created"}, :routine_id => routine.id)
      @stethoscope.routines << routine
    end

    respond_to do |format|
      if @stethoscope.save
        @stethoscope.get_status
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
    
    @stethoscope.routines.each do |routine|
      routine.events << Event.new(:status => 4, :returned => {"Notice" => "server name changed to #{params[:stethoscope][:server]}"})
    end
    
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
  
  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "bvdog" && password == "betatime"
    end
  end
end
