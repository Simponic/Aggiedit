# Aggiedit
Aggiedit will be a Reddit clone for university students and businesses with custom domains to share memes or discuss things. When a user registers with a new domain, if a "subaggie" doesn't already exist for that domain, it will be created. Otherwise, they have joined that "subaggie".

## Challenges
* Learning LiveView (I have experience with Phoenix, but want to checkout the real-time aspect of it)
* Email sending for authentcation (I've looked into sendgrid for my own domain)

## Requirements
* User authentication
  This app uses user authentication and verification to determine if someone actually belongs to a domain, in addition to providing an owner on each post.
* Database
  I will need to store rooms, posts, comments, uploads, etc. in a database and be able to make queries to it. 
* Publication
  This should be relatively easy since I can just copy most of my Docker stuff from my personal Phoenix projects.
* Usefulness
  This app will be useful in spreading discussion semi-anonymously.

## Timeline
| Task                                                                       |    Time  |
|----------------------------------------------------------------------------|----------|
| Setting up project with basic authentication from `mix phx.gen.auth`       |  1 hour  |
| Adding email verification with SendGrid                                    |  1 hour  |
| Creating real-time post timeline and models                                |  2 hours |
| Adding rooms for each domain; limiting posts to users within that domain   |  3 hours |
| Adding static image uploads                                                |  1 hour  |
| Associating uploads in db with a post                                      |  1 hour  |
| UI cleanup                                                                 |  4 hours |
| Deployment                                                                 |  2 hours |

Total: 15 hours
