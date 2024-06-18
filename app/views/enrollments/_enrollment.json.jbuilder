json.extract! enrollment, :id, :cohort, :name_first, :name_pref, :name_last, :needs_perm, :perm_prog, :perm_surveys, :trashed, :created_at, :updated_at
json.url enrollment_url(enrollment, format: :json)
