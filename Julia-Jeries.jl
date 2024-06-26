#=
  Assignment: Julia Program
  Course: CS 424-02
  Instructor: Professor Harry Delugach

  Student: Salwa Jeries
  Date: April 21, 2024

  Summary:
    This program reads in a "register.txt" file containing information about athletes and events, processes
    the relationships between them, then outputs the following information:

      - Each athlete's name, and the events they are participating in
      - Each event's title, and the athletes that are participating in it

    For the program design, I created an "Athlete" struct containing their ID, name, and a vector of corresponding
    event IDs to the events they were participating in. I also created an "Event" struct containing its ID, title,
    and a vector of corresponding athlete IDs to the athletes participating in the event. I created separate getter
    and setter functions for these structs, which would take in the struct to perform the desired operations with.

    The final two structs I made were the "AthleteList" and "EventList" structs, which contained vectors for their
    respective struct elements as well as some separate special functions. These two structs made managing all the
    athlete and event struct instances much easier. I also added some search functions that would find specific athlete
    or event elements by ID from the vectors in the class. 

    For the program flow, I followed the same general structure that I used in the original Ruby program assignemnt.
    Since the input file was divided into three sections, I created three different file read sections to handle
    the sets of data properly. The first section initialized each "Athlete" in the "AthleteList" struct, while the
    second section initialized each "Event" in the "EventList" struct. The third section would search for the
    "Athlete" struct with a matching ID to the file read in the "AthleteList" struct and assign it to the "Event"
    struct with a matching ID to the file read in the "EventList" struct. Similarly, it would assign the "Event"
    struct with a matching ID to the file read in the "EventList" struct to the "Athlete" struct with a matching
    ID to the file read in the "AthleteList" struct.

=#

mutable struct Athlete
  athlete_id::String
  name::String
  event_ids::Vector{String}
end

function Athlete(id::String, name::String)
  athlete = Athlete(id, name, [])
  return athlete
end

function add_event_id(athlete::Athlete, event_id::String)
  push!(athlete.event_ids, event_id)
end

function get_all_event_ids(athlete::Athlete)
  return athlete.event_ids
end

function get_athlete_id(athlete::Athlete)
  return athlete.athlete_id
end

function get_athlete_name(athlete::Athlete)
  return athlete.name
end

mutable struct Event
  event_id::String
  title::String
  athlete_ids::Vector{String}
end

function Event(event_id::String, title::String)
  event = Event(event_id, title, [])
  return event
end

function add_athlete_id(event::Event, athlete_id::String)
  push!(event.athlete_ids, athlete_id)
end

function get_all_athlete_ids(event::Event)
  return event.athlete_ids
end

function get_event_id(event::Event)
  return event.event_id
end

function get_event_title(event::Event)
  return event.title
end

mutable struct AthleteList
  list::Vector{Athlete}
end

function AthleteList()
  list = AthleteList([])
  return list
end

function add_athlete(athlete_list::AthleteList, athlete::Athlete)
  push!(athlete_list.list, athlete)
end

function get_athlete_by_id(athlete_list::AthleteList, athlete_id::String)
  for athlete in athlete_list.list
    if athlete.athlete_id == athlete_id
      return athlete
    end
  end
end

function get_list(athlete_list::AthleteList)
  return athlete_list.list
end

mutable struct EventList
  list::Vector{Event}
end

function EventList()
  list = EventList([])
  return list
end

function add_event(event_list::EventList, event::Event)
  push!(event_list.list, event)
end

function get_event_by_id(event_list::EventList, event_id::String)
  for event in event_list.list
    if event.event_id == event_id
      return event
    end
  end
end

function get_list(event_list::EventList)
  return event_list.list
end

file = open("register.txt")  # Open file
lines = readlines(file) # Read file as an array of lines
close(file)

# Split each line to be an element in array
# lines = split(lines, '\n')

# Athlete & event lists
all_athletes = AthleteList()
all_events = EventList()

# Loop for first section:
# Athlete ID, Athlete Name
for (index, line) in enumerate(lines)
  # If line is empty, new section
  if isempty(strip(line))
    global lines = lines[index+1:end]
    break # Exit loop for first section
  else
    items = split(line, " ", limit=2)  # Split into Athlete ID & Athlete Name
    add_athlete(all_athletes, Athlete(strip(items[1]), strip(items[2]), []))
  end
end

# Loop for second section:
# Event ID, Event Title
for (index, line) in enumerate(lines)
  # If line is empty, new section
  if isempty(strip(line))
    global lines = lines[index+1:end]
    break # Exit loop for second section
  else
    items = split(line, " ", limit=2)  # Split into Event ID & Event Title
    add_event(all_events, Event(strip(items[1]), strip(items[2]), []))
  end
end

# Loop for third section:
# Athlete ID, Event ID
for line in lines
  global all_athletes
  global all_events
  items = split(line, " ", limit=2)  # Split into Athlete ID & Event ID
  temp_athlete_id = string(strip(items[1]))
  temp_event_id = string(strip(items[2]))
  # Add event ID to athlete object
  add_event_id(get_athlete_by_id(all_athletes, temp_athlete_id), temp_event_id)
  # Add athlete ID to event object
  add_athlete_id(get_event_by_id(all_events, temp_event_id), temp_athlete_id)
end

# Print each athlete name and corresponding event titles
println("-------------------------")
println("ATHLETE LIST")
println("-------------------------")
for athlete in get_list(all_athletes)
  # Print athlete name
  println(athlete.name)
  println(" Events:")

  for (index, id) in enumerate(get_all_event_ids(athlete))
    # Print event title, numbered
    title = get_event_title(get_event_by_id(all_events, id))
    println(" $(index). $title")
  end
  println()
end

# Print each event title and corresponding athlete names
println("-------------------------")
println("EVENT LIST")
println("-------------------------")
for event in get_list(all_events)
  # Print event title
  println(event.title)
  println(" Participants:")

  for (index, id) in enumerate(get_all_athlete_ids(event))
    # Print athlete name, numbered
    name = get_athlete_name(get_athlete_by_id(all_athletes, id))
    println(" $(index). $name")
  end
  println()
end

#=
  Thoughts and Impressions:
    Once again, I found Julia to be relatively easy to pickup. It follows a similar style to Python and
    Ruby by using the implicit types and no semicolons for the end of line marker. It was interesting that
    Julia uses the same "end" marker for loops and conditional statements and the same print statements as
    Ruby. Another interesting observation was the explicit "global" variable reference to ensure that a loop
    or function knew whether it was referring to a local or global variable. This hindered writability slightly
    (although not by much), but helped with readability so that it was an explicit reminder of the scope of
    said variable.

    Not having objects meant that I had to change the structure of the Athlete and Event "elements" in the code
    compared to the previous assignment, however it was relatively straightforward. The structs were easy to
    define, and I used separate functions that would be passed an Athlete/Event struct to perform operations with
    it. Otherwise, the loss of objects had no affect on the program and I did not have to think of a different
    logic for performing the requirements of the assignment. Just based on the language itself and not based on
    the specific project/use case in which I would need to use these langauges, I would still pick Ruby over Julia.
    This is primarily because I enjoy the object-oriented features in Ruby, which are lost in Julia. Otherwise, they
    feel pretty similar and I would be willing to work with either one.
=#
