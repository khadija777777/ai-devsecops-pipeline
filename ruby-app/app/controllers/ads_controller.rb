class AdsController < ApplicationController
  before_action :set_ad, only: %i[show edit update destroy]

  # GET /ads
  def index
    @ads = Ad.all
  end

  # GET /ads/1
  def show
  end

  # GET /ads/new
  def new
    @ad = Ad.new
  end

  # GET /ads/1/edit
  def edit
  end

  # POST /ads
  def create
    @ad = Ad.new(ad_params)

    respond_to do |format|
      if @ad.save
        format.html { redirect_to @ad, notice: "Advertisement created successfully." }
        format.json { render :show, status: :created, location: @ad }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @ad.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /ads/1
  def update
    respond_to do |format|
      if @ad.update(ad_params)
        format.html { redirect_to @ad, notice: "Advertisement updated successfully.", status: :see_other }
        format.json { render :show, status: :ok, location: @ad }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @ad.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /ads/1
  def destroy
    @ad.destroy!

    respond_to do |format|
      format.html { redirect_to ads_path, notice: "Advertisement deleted successfully.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_ad
    @ad = Ad.find(params.expect(:id))
  end

def ad_params
  params.expect(
    ad: [
      :title,
      :description,
      :price,
      :category,
      :image,
      :ip_address,
      :operating_system,
      :criticality,
      :status,
      :last_scan_at
    ]
  )
end
end
