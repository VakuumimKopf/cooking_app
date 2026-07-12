@startchen

entity recipe{
  recipe_id : INT <<key>>
  name : STRING
}

entity tag{
  tag_id : INT <<key>>
  name : STRING
  color : COLORCODE
}

entity format{
  format_id : INT <<key>>
  name : STRING
  symbol : UNICODE
}

entity item{
  item_id : INT <<key>>
  recipe_id : INT <<fkey>>
  food_id : INT <<fkey>>
  format_id : INT <<fkey>>
  amount : DOUBLE
}

entity food{
  food_id : INT <<key>>
  name : STRING
  calories : DOUBLE
  fat : DOUBLE
  protein : DOUBLE
}

entity step{
  recipe_id : INT <<key>>
  text : STRING
  num : INT <<key>>
}

relationship tag_list{
  tag_id : INT <<key>>
  recipe : INT <<key>> 
}


item == format

recipe == item

step == recipe

tag_list == tag
tag_list == recipe 

food == item

@endchen
