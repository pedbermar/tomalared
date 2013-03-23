module VoteHelper
	def existeVotoPropietario(like_type, type_id, boton, likes)
		existe = false
		likes.each do |like|
			if like.user_id == current_user[:id] 
				if boton == "Mas" and like.like
					existe = true
				end
				if boton == "Menos" and like.dontlike
					existe = true
				end
			end
		end
		if like_type == 1
			id = "Post"
		elsif like_type == 2
			id = "Comment"
		end
		clase = ""
		if existe
			clase = "Disable"
		end
		if boton == "Menos"
			link_to '', {:controller => :vote, :action => 'vote', :like_type => like_type, :type_id => type_id, :dontLike => true }, :id => "votoMenos#{id}_#{type_id}", :class => "iconsMenos#{clase}", :remote => true
		elsif boton == "Mas"
			link_to '', {:controller => :vote, :action => 'vote', :like_type => like_type, :type_id => type_id, :like => true }, :id => "votoMas#{id}_#{type_id}", :class => "iconsMas#{clase}", :remote => true
		end
	end
	def numVotos(likes)
		num = 0
		likes.each do |like|
			if like.like
				num = num + 1
			end
			if like.dontlike
				num = num - 1
			end
		end
		return "#{num}"
	end
end
