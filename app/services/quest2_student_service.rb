class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.pluck(:codename).sort.join("\n")
    end

    # @return [String]
    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent.includes(:missions).order(:codename).map do |agent|
        mission_names = agent.missions.order(:title).pluck(:title).join(", ")
        "#{agent.codename}: #{mission_names}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      agents = Agent.includes(:missions).to_a

      agents.sort_by! do |agent|
        [ -agent.missions.size, agent.codename ]
      end

      agents.map do |agent|
        mission_names = agent.missions.order(:title).pluck(:title).join(", ")
        "#{agent.codename} (#{agent.missions.size}): #{mission_names}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.includes(:skills).order(:codename).map do |agent|
        skill_names = agent.skills.order(:name).pluck(:name).join(", ")
        "#{agent.codename}: #{skill_names}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      skills = Skill.includes(:agents).to_a

      skills_with_counts = skills.map do |skill|
        [ skill, skill.agents.size ]
      end

      skills_with_counts.sort_by! { |skill, count| [ -count, skill.name ] }

      skills_with_counts.map do |skill, count|
        agent_names = skill.agents.order(:codename).pluck(:codename).join(", ")
        "#{skill.name} (#{count}): #{agent_names}"
      end.join("\n")
    end
  end
end
