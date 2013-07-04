class VendasController < ApplicationController
  before_action :set_venda, only: [:show, :edit, :update, :destroy]
  #before_filter :authenticate_user!#  ,  :except => [:new, :create]
require 'gchart'
  # GET /vendas
  # GET /vendas.json
  def index
    @vendas = Venda.all
  end

  # GET /vendas/1
  # GET /vendas/1.json
  def show
  end

  # GET /vendas/new
  def new
    @venda = Venda.new
  end

  # GET /vendas/1/edit
  def edit
  end

  # POST /vendas
  # POST /vendas.json
  def create
    @venda = Venda.new(venda_params)
    #@venda.user_id=current_user.id
    if @venda.pessoa_fisica_id
      @venda.tipo_cliente=1
    else
      @venda.tipo_cliente=0
    end
    respond_to do |format|
      if @venda.save
        format.html { redirect_to @venda, notice: 'Venda was successfully created.' }
        format.json { render action: 'show', status: :created, location: @venda }
      else
        format.html { render action: 'new' }
        format.json { render json: @venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendas/1
  # PATCH/PUT /vendas/1.json
  def update
    respond_to do |format|
      if @venda.update(venda_params)
        format.html { redirect_to @venda, notice: 'Venda was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @venda.errors, status: :unprocessable_entity }
      end
    end
  end

  def relatorio_por_cliente
    #Relatorio Tabelas
    @vendaFisica=Venda.where(:tipo_cliente => 1)
    @vendaJuridica=Venda.where(:tipo_cliente => 0)
    
    #Relatorio Graficos
    @nroFis=Venda.where(:tipo_cliente=>1).count
    @nroJur=Venda.where(:tipo_cliente=>0).count

    @pizza=Gchart.pie_3d(:data => [@nroFis,@nroJur], :title => 'Vendas por Tipo de Cliente', :size => '400x200', :labels => ['Fisica', 'Juridica'])


    respond_to do |format|
      format.html
      format.json { render json: @vendaFisica and @vendaJuridica and @pizza }
    end
  end

  def relatorio_por_servico
    @servCruzeiro=Venda.where(:services_type=>1)
    @servEvento=Venda.where(:services_type=>2)
    @servPacote=Venda.where(:services_type=>3)
    @servPasseio=Venda.where(:services_type=>4)


    @nroCruzeiro=Venda.where(:services_type=>1).count
    @nroEvento=Venda.where(:services_type=>2).count
    @nroPacote=Venda.where(:services_type=>3).count
    @nroPasseio=Venda.where(:services_type=>4).count

    @pizza=Gchart.pie_3d(:data => [@nroCruzeiro,@nroEvento,@nroPacote,@nroPasseio], :title => 'Vendas por Tipo de Cliente', :size => '400x200', :labels => ['Cruzeiro', 'Evento', 'Pacote', 'Passeio'])


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @servCruzeiro and @servPasseio and @servPacote and @servEvento }
    end
  end

  def relatorio_por_venda
    
  end

  # DELETE /vendas/1
  # DELETE /vendas/1.json
  def destroy
    @venda.destroy
    respond_to do |format|
      format.html { redirect_to vendas_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venda
      @venda = Venda.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venda_params
      params.require(:venda).permit(:data_venda, :forma_pagamento, :status, :tipo_cliente, :valor_total, :pessoa_fisica_id, :pessoa_juridica_id, :user_id, :service_id)
    end
end
