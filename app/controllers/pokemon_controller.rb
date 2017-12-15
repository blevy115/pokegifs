class PokemonController < ApplicationController

  def show

    res = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{params[:id]}/")
    body = JSON.parse(res.body)
    if body["name"] || body["id"]
    name  = body["name"]
    id = body["id"]
    types = []
    body["types"].each { |type| types << type["type"]["name"] }

    res = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ENV["PokeGif_Key"]}&q=#{name}&rating=g")
    body = JSON.parse(res.body)
    gif_url = body["data"][rand(0..body["data"].length-1)]["url"]

    respond_to do |format|
      format.json {render json: {
        id: id,
        name: name,
        types: types,
        gif: gif_url,
        }
      }
      format.html {redirect_to gif_url}
    end

    else
    render :error
    end
end



end
