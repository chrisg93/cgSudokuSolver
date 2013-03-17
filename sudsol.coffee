GrilleView = Backbone.View.extend
  initialize: ->
    this.render()
  render: ->
    for i in [1..9]
      for j in [1..9]
        this.renderBox i, j
      this.$el.append "<br/>"
  renderBox: (i, j) ->
    template = _.template $("#box-template").html(),
      i:i
      j:j
    this.$el.append template
  events:
    "change input[type=text]": "doWork"
  doWork: (event) ->
    knownValue = event.target.value
    knownTarget = event.target.id
    POSITION_EXTRACTOR = /^box-(\d)-(\d)-val$/
    extract_result = POSITION_EXTRACTOR.exec knownTarget
    position_i = extract_result[1]
    position_j = extract_result[2]
    $("#box-#{position_i}-#{position_j}-possib").html "_"
    this.rmPossib knownValue, position_i, position_j
  rmPossib: (value, i, j) ->
    # Clear row
    for k in [1..9]
      this.rmBoxPossib value, i, k
    # CLear column
    for k in [1..9]
      this.rmBoxPossib value, k, j
    # Clear square
    if i < 4
      if j < 4
        for k in [1..3]
          for l in [1..3]  
            this.rmBoxPossib value, k, l
      else if j > 6
        for k in [1..3]
          for l in [7..9]  
            this.rmBoxPossib value, k, l
      else
        for k in [1..3]
          for l in [4..6]  
            this.rmBoxPossib value, k, l
    else if i > 6
      if j < 4
        for k in [7..9]
          for l in [1..3]  
            this.rmBoxPossib value, k, l
      else if j > 6
        for k in [7..9]
          for l in [7..9]  
            this.rmBoxPossib value, k, l
      else
        for k in [7..9]
          for l in [4..6]  
            this.rmBoxPossib value, k, l
    else
      if j < 4
        for k in [4..6]
          for l in [1..3]  
            this.rmBoxPossib value, k, l
      else if j > 6
        for k in [4..6]
          for l in [7..9]  
            this.rmBoxPossib value, k, l
      else
        for k in [4..6]
          for l in [4..6]  
            this.rmBoxPossib value, k, l
  rmBoxPossib: (value, i, j) ->
    SOLVED = /^\d$/
    newPossib = $("#box-#{i}-#{j}-possib").html()
    newPossib = newPossib.replace ",#{value}", "" 
    newPossib = newPossib.replace "#{value},", ""
    $("#box-#{i}-#{j}-possib").html newPossib
    if SOLVED.test newPossib then $("#box-#{i}-#{j}-possib").addClass "green"
    
grille_view = new GrilleView
  el: $("#grille")